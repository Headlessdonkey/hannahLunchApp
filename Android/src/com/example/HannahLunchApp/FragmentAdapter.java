package com.example.HannahLunchApp;

import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;

public class FragmentAdapter extends FragmentPagerAdapter {
    public FragmentAdapter(FragmentManager fm) {
        super(fm);
    }

    @Override
    public Fragment getItem(int i) {

        if(i == 0 ){
            return new PictureFragment();
        }
        else{
            return new MenuFragment();
        }
    }

    @Override
    public int getCount() {
        return 2;
    }
}
