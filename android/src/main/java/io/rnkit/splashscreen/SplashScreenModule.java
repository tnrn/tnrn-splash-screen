
package io.rnkit.splashscreen;

import android.app.Activity;
import android.app.Dialog;
import android.content.Context;
import android.graphics.drawable.Drawable;
import android.os.Build;
import android.os.Handler;
import android.os.Looper;
import android.support.annotation.Nullable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.view.animation.AlphaAnimation;
import android.view.animation.Animation;
import android.widget.ImageView;
import android.widget.ProgressBar;
import android.widget.TextView;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

public class SplashScreenModule extends ReactContextBaseJavaModule {
    private static Dialog splashDialog;

    private ProgressBar progressBar;
    private TextView tipTextView;

    private Activity activity;
    private boolean translucent;

    private static final int UIAnimationNone = 0;
    private static final int UIAnimationFade = 1;
    private static final int UIAnimationScale = 2;

    public SplashScreenModule(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @Override
    public String getName() {
        return "RNKitSplashScreenManager";
    }

    @ReactMethod
    public void open() {
        SplashScreen.show(getCurrentActivity());
    }

    @ReactMethod
    public void progress(final float progress) {

    }

    @ReactMethod
    public void tipText(final String tipText) {

    }

    @ReactMethod
    public void close(ReadableMap options) {
        SplashScreen.hide(getCurrentActivity());
    }
}