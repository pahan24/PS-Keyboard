package com.ps.keyboard

import android.inputmethodservice.InputMethodService
import android.view.View
import android.view.KeyEvent
import android.view.inputmethod.EditorInfo
import android.view.inputmethod.InputConnection
import android.view.inputmethod.InputMethodManager
import android.media.AudioManager
import android.os.Vibrator
import android.os.VibrationEffect
import android.os.Build
import android.content.Context
import android.content.ClipboardManager
import io.flutter.embedding.android.FlutterView
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel

class PSInputMethodService : InputMethodService() {
    private var flutterEngine: FlutterEngine? = null
    private var flutterView: FlutterView? = null
    private var channel: MethodChannel? = null

    companion object {
        const val CHANNEL = "com.ps.keyboard/input"
        const val ENGINE_ID = "ps_keyboard_engine"
    }

    override fun onCreate() {
        super.onCreate()
        initFlutterEngine()
    }

    private fun initFlutterEngine() {
        flutterEngine = FlutterEngineCache.getInstance().get(ENGINE_ID)
        if (flutterEngine == null) {
            val engine = FlutterEngine(this)
            engine.dartExecutor.executeDartEntrypoint(
                DartExecutor.DartEntrypoint.createDefault()
            )
            FlutterEngineCache.getInstance().put(ENGINE_ID, engine)
            flutterEngine = engine
        }

        channel = MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL)
        channel?.setMethodCallHandler { call, result ->
            val ic: InputConnection? = currentInputConnection
            when (call.method) {
                "commitText" -> {
                    val text = call.argument<String>("text") ?: ""
                    ic?.commitText(text, 1)
                    result.success(true)
                }
                "deleteSurroundingText" -> {
                    val before = call.argument<Int>("before") ?: 1
                    val after = call.argument<Int>("after") ?: 0
                    ic?.deleteSurroundingText(before, after)
                    result.success(true)
                }
                "sendKeyEvent" -> {
                    val keyCode = call.argument<Int>("keyCode") ?: 0
                    ic?.sendKeyEvent(KeyEvent(KeyEvent.ACTION_DOWN, keyCode))
                    ic?.sendKeyEvent(KeyEvent(KeyEvent.ACTION_UP, keyCode))
                    result.success(true)
                }
                "performEditorAction" -> {
                    val action = call.argument<Int>("action") ?: EditorInfo.IME_ACTION_DONE
                    ic?.performEditorAction(action)
                    result.success(true)
                }
                "playSound" -> {
                    val soundType = call.argument<Int>("soundType") ?: AudioManager.FX_KEYPRESS_STANDARD
                    val am = getSystemService(Context.AUDIO_SERVICE) as AudioManager
                    am.playSoundEffect(soundType)
                    result.success(true)
                }
                "vibrate" -> {
                    val duration = call.argument<Int>("duration") ?: 20
                    val vibrator = getSystemService(Context.VIBRATOR_SERVICE) as Vibrator
                    if (vibrator.hasVibrator()) {
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                            vibrator.vibrate(VibrationEffect.createOneShot(duration.toLong(), VibrationEffect.DEFAULT_AMPLITUDE))
                        } else {
                            @Suppress("DEPRECATION")
                            vibrator.vibrate(duration.toLong())
                        }
                    }
                    result.success(true)
                }
                "showInputMethodPicker" -> {
                    val imm = getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager
                    imm.showInputMethodPicker()
                    result.success(true)
                }
                "getClipboardText" -> {
                    val clipboard = getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
                    val clipData = clipboard.primaryClip
                    if (clipData != null && clipData.itemCount > 0) {
                        val text = clipData.getItemAt(0).text?.toString() ?: ""
                        result.success(text)
                    } else {
                        result.success("")
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    override fun onCreateInputView(): View {
        flutterView = FlutterView(this)
        flutterView?.attachToFlutterEngine(flutterEngine!!)
        return flutterView!!
    }

    override fun onDestroy() {
        flutterView?.detachFromFlutterEngine()
        super.onDestroy()
    }
}
