package com.example.HannahLunchApp;


import android.graphics.BitmapFactory;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import com.parse.*;

import java.util.List;

public class PictureFragment extends Fragment {

    List<ParseObject> queriedObjects;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        return inflater.inflate(R.layout.picturefragment, container, false);
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        new RemoteDataTask().execute();
    }

    private class RemoteDataTask extends AsyncTask<Void, Void, Void> {
        protected Void doInBackground(Void... params) {
            ParseQuery<ParseObject> query = new ParseQuery<ParseObject>("Current_Menu");
            query.orderByDescending("_created_at");
            query.setLimit(1);

            try {
                queriedObjects = query.find();
            } catch (ParseException e) {
                Log.d(e.toString(), "");
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
                            if(getActivity() != null){
                                ((ImageView)getActivity().findViewById(R.id.imageView))
                                        .setImageBitmap(BitmapFactory.decodeByteArray(data, 0, data.length));
                            }
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
