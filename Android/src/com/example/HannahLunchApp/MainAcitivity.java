package com.example.HannahLunchApp;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Context;
import android.graphics.BitmapFactory;
import android.os.AsyncTask;
import android.os.Bundle;
import android.util.AttributeSet;
import android.util.Log;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;
import com.parse.*;

import java.util.ArrayList;
import java.util.List;

public class MainAcitivity extends Activity {

    List<ParseObject> queriedObjects;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setupParse();
        setContentView(R.layout.main);
        getActionBar().hide();
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

    @Override
    protected void onResume() {
        super.onResume();

        new RemoteDataTask().execute();
    }

    private class RemoteDataTask extends AsyncTask<Void, Void, Void> {
        // Override this method to do custom remote calls
        protected Void doInBackground(Void... params) {
            // Gets the current list of todos in sorted order
            ParseQuery<ParseObject> query = new ParseQuery<ParseObject>("Current_Menu");
            query.orderByDescending("_created_at");
            query.setLimit(1);

            try {
                queriedObjects = query.find();
            } catch (ParseException e) {
                Log.d(e.toString(),"");
            }
            return null;
        }

        @Override
        protected void onPreExecute() {
            super.onPreExecute();
        }

        @Override
        protected void onProgressUpdate(Void... values) {

            super.onProgressUpdate(values);
        }

        @Override
        protected void onPostExecute(Void result) {
            if(queriedObjects != null && queriedObjects.size() > 0){
                ParseFile imageFile = (ParseFile)queriedObjects.get(0).get("imageFile");
                imageFile.getDataInBackground(new GetDataCallback() {
                    public void done(byte[] data, ParseException e) {
                        if (e == null) {
                            ((ImageView)findViewById(R.id.imageView)).setImageBitmap(BitmapFactory.decodeByteArray(data,0,data.length));
                        } else {
                            Log.d(e.toString(),"");
                        }
                    }
                });
            }
            else{
            }
        }
    }
}
