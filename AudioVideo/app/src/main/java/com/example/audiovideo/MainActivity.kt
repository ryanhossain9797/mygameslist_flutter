package com.example.audiovideo

import android.net.Uri
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import android.widget.MediaController
import kotlinx.android.synthetic.main.activity_main.*
import java.net.URI

class MainActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        try {
            val controller = MediaController(this)
            videoView.setVideoPath("https://videocdn.bodybuilding.com/video/mp4/62000/62792m.mp4")
            videoView.start()
            videoView.setMediaController(controller)
        }
        catch(e: Exception){
            Log.e("ErrOnLoad", e.message!!)
        }
    }
}
