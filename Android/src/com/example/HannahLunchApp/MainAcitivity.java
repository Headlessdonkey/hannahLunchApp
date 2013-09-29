package com.example.HannahLunchApp;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Context;
import android.graphics.BitmapFactory;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v4.app.FragmentActivity;
import android.support.v4.view.ViewPager;
import android.util.AttributeSet;
import android.util.Log;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;
import com.parse.*;
import com.viewpagerindicator.CirclePageIndicator;

import java.util.ArrayList;
import java.util.List;

public class MainAcitivity extends FragmentActivity {

    ViewPager viewPager;
    CirclePageIndicator indicator;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setupParse();
        setContentView(R.layout.main);
        getActionBar().hide();
        viewPager = (ViewPager) findViewById(R.id.pager);

        viewPager.setAdapter(new FragmentAdapter(getSupportFragmentManager()));

        indicator = (CirclePageIndicator) findViewById(R.id.indicator);
        indicator.setViewPager(viewPager);
    }

    private void setupParse(){

        Parse.initialize(this, "uMhRJ0N5965dSn0D56RkIHvf0pn2sNoVLtc95UTF", "KLeACb4vLQVxsowNZdOy01MjDTwKJsNNY7Niw9Lv");


        ParseUser.enableAutomaticUser();
        ParseACL defaultACL = new ParseACL();
        // Optionally enable public read access.
        defaultACL.setPublicReadAccess(true);
        ParseACL.setDefaultACL(defaultACL, true);

        PushService.subscribe(this,"Lunch_Channel",MainAcitivity.class);
        ParseInstallation.getCurrentInstallation().saveInBackground();

    }


}
