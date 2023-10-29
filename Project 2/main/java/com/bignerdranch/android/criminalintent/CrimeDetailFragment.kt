package com.bignerdranch.android.criminalintent

import android.R.attr.bitmap
import android.content.Intent

import android.content.pm.PackageManager
import android.content.pm.ResolveInfo
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.graphics.Path
import android.graphics.Rect
import android.net.Uri
import android.os.Bundle
import android.provider.ContactsContract
import android.text.format.DateFormat
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import androidx.activity.result.contract.ActivityResultContracts
import androidx.annotation.ColorInt
import androidx.core.content.FileProvider
import androidx.core.view.doOnLayout
import androidx.core.widget.doOnTextChanged
import androidx.fragment.app.Fragment
import androidx.fragment.app.setFragmentResultListener
import androidx.fragment.app.viewModels
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.lifecycleScope
import androidx.lifecycle.repeatOnLifecycle
import androidx.navigation.fragment.findNavController
import androidx.navigation.fragment.navArgs
import com.bignerdranch.android.criminalintent.databinding.FragmentCrimeDetailBinding
import com.google.android.gms.tasks.Task
import kotlinx.coroutines.launch
import java.io.File
import java.util.Date
import com.google.mlkit.vision.common.InputImage
import com.google.mlkit.vision.common.Triangle
import com.google.mlkit.vision.facemesh.*
import com.google.mlkit.vision.face.FaceDetection
import com.google.mlkit.vision.face.FaceDetectorOptions
import com.google.mlkit.vision.segmentation.Segmentation
import com.google.mlkit.vision.segmentation.SegmentationMask
import com.google.mlkit.vision.segmentation.Segmenter
import com.google.mlkit.vision.segmentation.selfie.SelfieSegmenterOptions
import java.nio.ByteBuffer


private const val DATE_FORMAT = "EEE, MMM, dd"

class CrimeDetailFragment : Fragment() {

    private var option=0
    private var _binding: FragmentCrimeDetailBinding? = null
    private val binding
        get() = checkNotNull(_binding) {
            "Cannot access binding because it is null. Is the view visible?"
        }

    private var count=3
    private var quarter=0
    private var photoUri: Uri? = null
    private val args: CrimeDetailFragmentArgs by navArgs()

    private val crimeDetailViewModel: CrimeDetailViewModel by viewModels {
        CrimeDetailViewModelFactory(args.crimeId)
    }

    private val selectSuspect = registerForActivityResult(
        ActivityResultContracts.PickContact()
    ) { uri: Uri? ->
        uri?.let { parseContactSelection(it) }
    }

    private var photoName: String? = null
    private var scaledBitmap: Bitmap? = null

    private val takePhoto = registerForActivityResult(
        ActivityResultContracts.TakePicture()
    ) { didTakePhoto: Boolean ->
        if (didTakePhoto && photoName != null) {
            crimeDetailViewModel.updateCrime { oldCrime ->
                oldCrime.copy(photoFileName = photoName)
            }

        }
    }

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        _binding =
            FragmentCrimeDetailBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        binding.apply {
            crimeTitle.doOnTextChanged { text, _, _, _ ->
                crimeDetailViewModel.updateCrime { oldCrime ->
                    oldCrime.copy(title = text.toString())
                }
            }

            crimeSolved.setOnCheckedChangeListener { _, isChecked ->
                crimeDetailViewModel.updateCrime { oldCrime ->
                    oldCrime.copy(isSolved = isChecked)
                }
            }

            crimeSuspect.setOnClickListener {
                selectSuspect.launch(null)
            }

            val selectSuspectIntent = selectSuspect.contract.createIntent(
                requireContext(),
                null
            )
            crimeSuspect.isEnabled = canResolveIntent(selectSuspectIntent)

            //Click checkbox
            //Face detection

            checkBox1.setOnClickListener{
                checkBox2.isChecked = false;
                checkBox3.isChecked = false;
                checkBox4.isChecked = false;
            };

            //contour detection
            checkBox2.setOnClickListener{
                checkBox1.isChecked = false;
                checkBox3.isChecked = false;
                checkBox4.isChecked = false;
            };

            //mash detection
            checkBox3.setOnClickListener{
                checkBox2.isChecked = false;
                checkBox1.isChecked = false;
                checkBox4.isChecked = false;
            };

            //selfie segmentation
            checkBox4.setOnClickListener{
                checkBox2.isChecked = false;
                checkBox3.isChecked = false;
                checkBox1.isChecked = false;
            };

            // Click the camera icon to take a photo and update the photo file name of the criminal record
            crimeCamera.setOnClickListener {
                photoName = "IMG_${count}.JPG"
                count += 1
                option = when {
                    checkBox1.isChecked -> 1
                    checkBox2.isChecked -> 2
                    checkBox3.isChecked -> 3
                    checkBox4.isChecked -> 4
                    else -> 0
                }
                val photoFile = File(
                    requireContext().applicationContext.filesDir,
                    photoName
                )
                photoUri = FileProvider.getUriForFile(
                    requireContext(),
                    "com.bignerdranch.android.criminalintent.fileprovider",
                    photoFile
                )
                takePhoto.launch(photoUri)


            }

            val captureImageIntent = takePhoto.contract.createIntent(
                requireContext(),
                null
            )
            crimeCamera.isEnabled = canResolveIntent(captureImageIntent)
        }

        viewLifecycleOwner.lifecycleScope.launch {
            viewLifecycleOwner.lifecycle.repeatOnLifecycle(Lifecycle.State.STARTED) {
                crimeDetailViewModel.crime.collect { crime ->
                    crime?.let { updateUi(it) }
                }
            }
        }

        setFragmentResultListener(
            DatePickerFragment.REQUEST_KEY_DATE
        ) { _, bundle ->
            val newDate =
                bundle.getSerializable(DatePickerFragment.BUNDLE_KEY_DATE) as Date
            crimeDetailViewModel.updateCrime { it.copy(date = newDate) }
        }
    }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }

    private fun updateUi(crime: Crime) {
        binding.apply {
            if (crimeTitle.text.toString() != crime.title) {
                crimeTitle.setText(crime.title)
            }
            crimeDate.text = crime.date.toString()
            crimeDate.setOnClickListener {
                findNavController().navigate(
                    CrimeDetailFragmentDirections.selectDate(crime.date)
                )
            }

            crimeSolved.isChecked = crime.isSolved

            crimeReport.setOnClickListener {
                val reportIntent = Intent(Intent.ACTION_SEND).apply {
                    type = "text/plain"
                    putExtra(Intent.EXTRA_TEXT, getCrimeReport(crime))
                    putExtra(
                        Intent.EXTRA_SUBJECT,
                        getString(R.string.crime_report_subject)
                    )
                }
                val chooserIntent = Intent.createChooser(
                    reportIntent,
                    getString(R.string.send_report)
                )
                startActivity(chooserIntent)
            }

            crimeSuspect.text = crime.suspect.ifEmpty {
                getString(R.string.crime_suspect_text)
            }
            // 更新犯罪照片
            updatePhoto(crime.photoFileName)
        }
    }

    private fun getCrimeReport(crime: Crime): String {
        val solvedString = if (crime.isSolved) {
            getString(R.string.crime_report_solved)
        } else {
            getString(R.string.crime_report_unsolved)
        }

        val dateString = DateFormat.format(DATE_FORMAT, crime.date).toString()
        val suspectText = if (crime.suspect.isBlank()) {
            getString(R.string.crime_report_no_suspect)
        } else {
            getString(R.string.crime_report_suspect, crime.suspect)
        }

        return getString(
            R.string.crime_report,
            crime.title, dateString, solvedString, suspectText
        )
    }

    private fun parseContactSelection(contactUri: Uri) {
        val queryFields = arrayOf(ContactsContract.Contacts.DISPLAY_NAME)

        val queryCursor = requireActivity().contentResolver
            .query(contactUri, queryFields, null, null, null)

        queryCursor?.use { cursor ->
            if (cursor.moveToFirst()) {
                val suspect = cursor.getString(0)
                crimeDetailViewModel.updateCrime { oldCrime ->
                    oldCrime.copy(suspect = suspect)
                }
            }
        }
    }

    private fun canResolveIntent(intent: Intent): Boolean {
        val packageManager: PackageManager = requireActivity().packageManager
        val resolvedActivity: ResolveInfo? =
            packageManager.resolveActivity(
                intent,
                PackageManager.MATCH_DEFAULT_ONLY
            )
        return resolvedActivity != null
    }

    private fun updatePhoto(photoFileName: String?) {
        val photoViews = arrayOf(binding.crimePhoto1, binding.crimePhoto2, binding.crimePhoto3, binding.crimePhoto4)
        quarter = count % 4
        if (photoViews[quarter].tag != photoFileName) {
            val photoFile = photoFileName?.let {
                File(requireContext().applicationContext.filesDir, it)
            }

            if (photoFile?.exists() == true) {
                photoViews[quarter].doOnLayout { measuredView ->
                        scaledBitmap = getScaledBitmap(
                        photoFile.path,
                        measuredView.width,
                        measuredView.height
                    )
                    photoViews[quarter].setImageBitmap(scaledBitmap)
                    photoViews[quarter].tag = photoFileName
                    photoViews[quarter].contentDescription =
                        getString(R.string.crime_photo_image_description)
                }
            } else {
                photoViews[quarter].setImageBitmap(null)
                photoViews[quarter].tag = null
                photoViews[quarter].contentDescription =
                    getString(R.string.crime_photo_no_image_description)
            }
        }
        when (option) {
            1 -> processImage(option) { faceDetection(it) }
            2 -> processImage(option) { facecontourDetection(it) }
            3 -> processImage(option) { meshDetection(it) }
            4 -> processImage(option) { selfsegDetection(it) }
        }
    }

    private fun processImage(option: Int, imageProcessingFunction: (ImageView) -> Unit) {
        quarter = (count - 3) % 4
        val imageviewselect: ImageView = when (quarter) {
            1 -> binding.crimePhoto1
            2 -> binding.crimePhoto2
            3 -> binding.crimePhoto3
            else -> binding.crimePhoto4
        }
        if (option in 1..4) {
            imageProcessingFunction(imageviewselect)
        }
    }


    //Mesh detection
    private fun meshDetection(imageView: ImageView){
        val detector = FaceMeshDetection.getClient()
        val image = InputImage.fromBitmap(scaledBitmap!!, 0)
        val faces = detector.process(image)
            .addOnSuccessListener { faces ->
                    for (face in faces) {
                        val bounds: Rect = face.boundingBox
                        val faceMeshPoints = face.allPoints

                        val triangles: MutableList<Triangle<FaceMeshPoint>> = face.allTriangles
                        // Create a mutable copy of the bitmap to draw on
                        val mutableBitmap = scaledBitmap!!.copy(Bitmap.Config.ARGB_8888, true)
                        val canvas = Canvas(mutableBitmap)

                        // Define paint styles for points and lines.
                        val pointPaint = Paint().apply {
                            color = Color.RED
                            style = Paint.Style.FILL
                        }
                        val linePaint = Paint().apply {
                            color = Color.BLUE
                            style = Paint.Style.STROKE
                        }

                        // Draw each face mesh point as a small circle
                        for((index,faceMeshpoint) in faceMeshPoints.withIndex()) {
                            val position = faceMeshpoint.position
                            canvas.drawCircle(position.x, position.y, 2f, pointPaint)
                            }

                            // Draw each triangle.
                        for(triangle in triangles) {
                            val path = Path().apply {
                                val startPoint = triangle.allPoints[0].position
                                moveTo(startPoint.x, startPoint.y)
                                for (i in 1 until triangle.allPoints.size){
                                    val point = triangle.allPoints[i].position
                                    lineTo(point.x, point.y)
                                }
                                close()
                            }
                            canvas.drawPath(path, linePaint)
                        }
                        // Update ImageView with the new bitmap
                        imageView.setImageBitmap(mutableBitmap)
                    }
            }
            .addOnFailureListener {exception ->
                print(exception.localizedMessage)
            }
    }

    //Face detection
    private fun faceDetection(imageView: ImageView) {
        val detector = FaceDetection.getClient()
        val image = InputImage.fromBitmap(scaledBitmap!!, 0)

        val faces = detector.process(image)
            .addOnSuccessListener { faces ->
                val mutableBitmap = scaledBitmap!!.copy(Bitmap.Config.ARGB_8888, true)
                val canvas = Canvas(mutableBitmap)

                // Define a paint style for drawing rectangles
                val rectPaint = Paint().apply {
                    color = Color.GREEN
                    style = Paint.Style.STROKE
                    strokeWidth = 5f
                }

                for (face in faces) {
                    val bounds: Rect = face.boundingBox
                    // Draw a rectangle around the detected face
                    canvas.drawRect(bounds, rectPaint)
                }
                    // Update ImageView with the new bitmap
                    imageView.setImageBitmap(mutableBitmap)

                // Update the TextView with the number of faces detected
                val faceCountTextView = binding.facesDetected
                faceCountTextView.text = "Faces Detected: ${faces.size}"
            }
            .addOnFailureListener { exception ->
                print(exception.localizedMessage)
            }
    }

    //Contour detection
    private fun facecontourDetection(imageView: ImageView) {
        val detector = FaceDetection.getClient()
        val image = InputImage.fromBitmap(scaledBitmap!!, 0)

        val contourOptions = FaceDetectorOptions.Builder()
            .setContourMode(FaceDetectorOptions.CONTOUR_MODE_ALL)
            .build()
        val contourDetector = FaceDetection.getClient(contourOptions)

        val mutableBitmap = scaledBitmap!!.copy(Bitmap.Config.ARGB_8888, true)
        val canvas = Canvas(mutableBitmap)

        val pen = Paint()
        pen.strokeWidth = (scaledBitmap!!.width + scaledBitmap!!.height).toFloat() / 500
        pen.style = Paint.Style.STROKE
        pen.color = Color.GREEN

        val faces = contourDetector.process(image)
            .addOnSuccessListener { faces ->
                for (face in faces) {
                    val contours = face.allContours
                    for (contour in contours) {
                        val points = contour.points
                        for (i in 1 until points.size) {
                            canvas.drawLine(
                                points[i - 1].x,
                                points[i - 1].y,
                                points[i].x,
                                points[i].y,
                                pen
                            )
                        }
                    }
                }
                // Update ImageView with the new bitmap
                imageView.setImageBitmap(mutableBitmap)
        }
            .addOnFailureListener { exception ->
                print(exception.localizedMessage)
            }
    }

    //Selfie Segmentation
    private val selfieSegmenter : Segmenter
    private lateinit var mask :ByteBuffer
    private var maskWidth : Int
    private var maskHeight : Int

    init{
        val options = SelfieSegmenterOptions.Builder()
            .setDetectorMode(SelfieSegmenterOptions.SINGLE_IMAGE_MODE)
            .build()
        selfieSegmenter = Segmentation.getClient(options)
        maskWidth = 0
        maskHeight = 0
    }

// Update the callSelfieSegmentation function
    private fun selfsegDetection(imageView: ImageView): Task<SegmentationMask> {
        val image = InputImage.fromBitmap(scaledBitmap!!, 0)
        val bitmap = scaledBitmap!!.copy(Bitmap.Config.ARGB_8888, true)

        return selfieSegmenter.process(image)
            .addOnSuccessListener { segmentationMask ->
                // Task completed successfully
                val updatedBitmap = applySegmentationMask(segmentationMask, bitmap)
                imageView.setImageBitmap(updatedBitmap)
            }
    }
    // Update the successFunction function
    private fun applySegmentationMask(segmentationMask: SegmentationMask, bitmap: Bitmap): Bitmap {
        mask = segmentationMask.buffer
        maskWidth = segmentationMask.width
        maskHeight = segmentationMask.height
        val maskBitmap = Bitmap.createBitmap(
            maskColorsFromByteBuffer(mask),
            maskWidth,
            maskHeight,
            Bitmap.Config.ARGB_8888
        )
        val resultBitmap = Bitmap.createBitmap(bitmap.width, bitmap.height, Bitmap.Config.ARGB_8888)
        val canvas = Canvas(resultBitmap)
        val paint = Paint()
        canvas.drawBitmap(bitmap, 0f, 0f, paint)
        canvas.drawBitmap(maskBitmap, 0f, 0f, paint)
        // Reset byteBuffer pointer to the beginning, so that the mask can be redrawn if the screen is refreshed
        mask.rewind()
        return resultBitmap
    }

    /** Converts byteBuffer floats to ColorInt array that can be used as a mask.  */
    @ColorInt
    private fun maskColorsFromByteBuffer(byteBuffer: ByteBuffer): IntArray {
        @ColorInt val colors = IntArray(maskWidth * maskHeight)
        for (i in 0 until maskWidth * maskHeight)
        {
            val backgroundLikelihood = byteBuffer.float
            if (backgroundLikelihood > 0.9) {
                colors[i] = Color.argb(128, 255, 0, 255)
            } else if (backgroundLikelihood > 0.2) {
                // Linear interpolation to make sure when backgroundLikelihood is 0.2, the alpha is 0 and
                // when backgroundLikelihood is 0.9, the alpha is 128.
                // +0.5 to round the float value to the nearest int.
                val alpha = (182.9 * backgroundLikelihood - 36.6 + 0.5).toInt()
                colors[i] = Color.argb(alpha, 255, 0, 255)
            }
        }
        return colors
    }

}

