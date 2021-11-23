package com.constructin.ci_connectivity.ci_connectivity;

import android.content.Context;
import android.net.ConnectivityManager;
import android.net.Network;
import android.net.NetworkCapabilities;
import android.net.NetworkInfo;
import android.os.Build;

import androidx.annotation.RequiresApi;

import java.io.IOException;
import java.net.URL;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;

import javax.net.ssl.HttpsURLConnection;

public class CIConnectivity {

    private final ExecutorService executor = Executors.newSingleThreadExecutor();

    public boolean isNetworkAvailable(Context context) {
        ConnectivityManager cm = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);
        if (cm == null) return false;

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {

            NetworkCapabilities cap = cm.getNetworkCapabilities(cm.getActiveNetwork());
            if (cap == null) return false;
            return cap.hasCapability(NetworkCapabilities.NET_CAPABILITY_INTERNET);

        } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {

            Network[] networks = cm.getAllNetworks();
            for (Network n: networks) {
                NetworkInfo nInfo = cm.getNetworkInfo(n);
                if (nInfo != null && nInfo.isConnected()) return true;
            }

        } else {

            NetworkInfo[] networks = cm.getAllNetworkInfo();
            for (NetworkInfo nInfo: networks) {
                if (nInfo != null && nInfo.isConnected()) return true;
            }

        }

        return false;
    }

    public boolean checkConnection(Context context) {
        if (this.isNetworkAvailable(context)) {
            Future<Boolean> response = executor.submit(this::_requestToCheckNetwork);
            try {
                final boolean respTemp = response.get();
                executor.shutdown();
                return respTemp;
            } catch (ExecutionException e) {
                e.printStackTrace();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
        return false;
    }

    private boolean _requestToCheckNetwork() throws IOException {
        HttpsURLConnection urlc = (HttpsURLConnection)
                new URL("https://clients3.google.com/generate_204")
                .openConnection();
        urlc.setRequestProperty("User-Agent", "Android");
        urlc.setRequestProperty("Connection", "close");
        urlc.setConnectTimeout(1000);
        urlc.connect();
        return urlc.getResponseCode() == 204 && urlc.getContentLength() == 0;
    }

}
