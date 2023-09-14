package com.example.screen3

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.View
import android.webkit.WebView
import android.webkit.WebViewClient
import android.widget.Button

class MainActivity : AppCompatActivity() {

    private lateinit var web1: Button
    private lateinit var web2: Button
    private lateinit var web3: Button
    private lateinit var webView: WebView

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        web1 = findViewById(R.id.website1)
        web2 = findViewById(R.id.website2)
        web3 = findViewById(R.id.website3)
        webView = findViewById(R.id.website)

        webView.webViewClient = WebViewClient()
        webView.settings.javaScriptEnabled = true

        webView.loadUrl("https://www.google.com")

        web1.setOnClickListener { this.webView.loadUrl("https://www.google.com") }

        web2.setOnClickListener {
            this.webView.loadUrl("https://www.facebook.com") }

        web3.setOnClickListener {
            this.webView.loadUrl("https://www.wpi.edu") }
    }

}