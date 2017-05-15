
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

    public SplashScreenModule(ReactApplicationContext reactContext, Activity activity, boolean translucent) {
        super(reactContext);
        this.activity = activity;
        this.translucent = translucent && Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP;
        showSplashScreen();
    }

    @Override
    public String getName() {
        return "RNKitSplashScreenManager";
    }

    protected Activity getActivity() {
        return activity;
    }

    @Nullable
    @Override
    public Map<String, Object> getConstants() {
        return Collections.unmodifiableMap(new HashMap<String, Object>() {
            {
                put("animationType", getAnimationTypes());
            }
            private Map<String, Object> getAnimationTypes() {
                return Collections.unmodifiableMap(new HashMap<String, Object>() {
                    {
                        put("none", UIAnimationNone);
                        put("fade", UIAnimationFade);
                        put("scale", UIAnimationScale);
                    }
                });
            }
        });
    }

    @ReactMethod
    public void open() {
        this.loadBundle();
        this.showSplashScreen();
    }

    @ReactMethod
    public void progress(final float progress) {
        getActivity().runOnUiThread(new Runnable() {
            public void run() {
                if (progressBar != null) {
                    if (!progressBar.isSelected()) {
                        progressBar.setVisibility(View.VISIBLE);
                        progressBar.setSelected(true);
                    }
                    progressBar.setProgress((int)(progress * 100));
                }
            }
        });
    }

    @ReactMethod
    public void tipText(final String tipText) {
        getActivity().runOnUiThread(new Runnable() {
            public void run() {
                if (tipTextView != null) {
                    if (!tipTextView.isSelected()) {
                        tipTextView.setVisibility(View.VISIBLE);
                        tipTextView.setSelected(true);
                    }
                    tipTextView.setText(tipText);
                }
            }
        });
    }

    @ReactMethod
    public void close(ReadableMap options) {
        final Handler handler = new Handler();
        handler.postDelayed(new Runnable() {
            public void run() {
                removeSplashScreen();
            }
        }, 500);
    }

    private void loadBundleLegacy() {
        final Activity currentActivity = getCurrentActivity();
        if (currentActivity == null) {
            // The currentActivity can be null if it is backgrounded / destroyed, so we simply
            // no-op to prevent any null pointer exceptions.
            return;
        }

        currentActivity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                currentActivity.recreate();
            }
        });
    }

    public void setSplashImage (Drawable drawable) {
        progressBar.setProgressDrawable(drawable);
    }

    private void loadBundle() {
        try {
            new Handler(Looper.getMainLooper()).post(new Runnable() {
                @Override
                public void run() {
                    loadBundleLegacy();
                }
            });
        } catch (Exception e) {
            loadBundleLegacy();
        }
    }

    private void removeSplashScreen() {
        getActivity().runOnUiThread(new Runnable() {
            public void run() {
                if (splashDialog != null && splashDialog.isShowing()) {
                    AlphaAnimation fadeOut = new AlphaAnimation(1, 0);
                    fadeOut.setDuration(1000);
                    View view = ((ViewGroup) splashDialog.getWindow().getDecorView()).getChildAt(0);
                    view.startAnimation(fadeOut);
                    fadeOut.setAnimationListener(new Animation.AnimationListener() {
                        @Override
                        public void onAnimationStart(Animation animation) {
                        }

                        @Override
                        public void onAnimationEnd(Animation animation) {
                            splashDialog.dismiss();
                            splashDialog = null;
                        }

                        @Override
                        public void onAnimationRepeat(Animation animation) {
                        }
                    });
                }
            }
        });
    }

    private int getSplashId() {
        int drawableId = getActivity().getResources().getIdentifier("splash", "drawable", getActivity().getClass().getPackage().getName());
        if (drawableId == 0) {
            drawableId = getActivity().getResources().getIdentifier("splash", "drawable", getActivity().getPackageName());
        }
        return drawableId;
    }

    private void showSplashScreen() {
        final int drawableId = getSplashId();
        if ((splashDialog != null && splashDialog.isShowing()) || (drawableId == 0)) {
            return;
        }
        getActivity().runOnUiThread(new Runnable() {
            public void run() {
                Context context = getActivity();

                View view = LayoutInflater.from(context).inflate(R.layout.dialog_splash, null, false);
                ((ImageView)view.findViewById(R.id.imageView)).setImageResource(drawableId);

                splashDialog = new Dialog(context, translucent ? android.R.style.Theme_Translucent_NoTitleBar_Fullscreen : android.R.style.Theme_Translucent_NoTitleBar);
                if ((getActivity().getWindow().getAttributes().flags & WindowManager.LayoutParams.FLAG_FULLSCREEN)
                        == WindowManager.LayoutParams.FLAG_FULLSCREEN) {
                    splashDialog.getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,
                            WindowManager.LayoutParams.FLAG_FULLSCREEN);
                }
                progressBar = (ProgressBar) view.findViewById(R.id.progressBar);
                tipTextView = (TextView) view.findViewById(R.id.textView);
                splashDialog.setContentView(view);
                splashDialog.setCancelable(false);
                if (activity != null && !activity.isFinishing()) {
                    splashDialog.show();
                }
            }
        });
    }
}