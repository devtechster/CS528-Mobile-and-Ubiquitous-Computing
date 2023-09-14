package com.example.screen2

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.View
import android.widget.Button
import android.widget.ImageButton
import android.widget.ImageView
import android.widget.TextView

class MainActivity : AppCompatActivity() {
    private var clickCounter1 = 0
    private var clickCounter2 = 0
    private var clickCounter3 = 0

    private lateinit var img1 : ImageView
    private lateinit var img2 : ImageView
    private lateinit var img3 : ImageView

    private lateinit var show1 : TextView
    private lateinit var show2 : TextView
    private lateinit var show3 : TextView
    private lateinit var resetButton : Button


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        img1 = findViewById(R.id.image_1)
        img2 = findViewById(R.id.image_2)
        img3 = findViewById(R.id.image_3)

        show1 = findViewById(R.id.show_1)
        show2 = findViewById(R.id.show_2)
        show3 = findViewById(R.id.show_3)
        resetButton = findViewById(R.id.reset)

        val message1 = "You have pressed the image $clickCounter1 times"
        show1.text = message1

        val message2 = "You have pressed the image $clickCounter2 times"
        show2.text = message2

        val message3 = "You have pressed the image $clickCounter3 times"
        show3.text = message3

        img1.setOnClickListener(object: View.OnClickListener{
            override fun onClick(view:View?){
                clickCounter1++
                val message1 = "You have pressed the image $clickCounter1 times"
                show1.text = message1
            }})

        img2.setOnClickListener(object: View.OnClickListener{
            override fun onClick(view:View?){
                clickCounter2++
                val message2 = "You have pressed the image $clickCounter2 times"
                show2.text = message2
            }})

        img3.setOnClickListener(object: View.OnClickListener{
            override fun onClick(view:View?){
                clickCounter3++
                val message3 = "You have pressed the image $clickCounter3 times"
                show3.text = message3
            }})

        resetButton.setOnClickListener(object: View.OnClickListener{
            override fun onClick(view:View?){
                clickCounter3 =0
                clickCounter1 =0
                clickCounter2 =0

                show1.text = "You have pressed the image $clickCounter1 times"
                show2.text = "You have pressed the image $clickCounter2 times"
                show3.text = "You have pressed the image $clickCounter3 times"
            }})


    }
}