package com.example.c16339923.httpget;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import com.android.volley.RequestQueue;
import com.android.volley.toolbox.Volley;
import com.android.volley.toolbox.StringRequest;
import com.android.volley.Request;
import com.android.volley.Response;
import com.android.volley.VolleyError;

public class MainActivity extends AppCompatActivity {
    TextView sayHello;
    EditText editedName;
    Button send;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        sayHello = findViewById(R.id.sayHello);
        editedName = findViewById(R.id.name);
        send = findViewById(R.id.send);
    }

    public void greetName(View v) {
        final String name = editedName.getText().toString();
        // Instantiate the RequestQueue.
        RequestQueue queue = Volley.newRequestQueue(this);
        String url ="http://www.wdylike.appspot.com/?q="+name;

        // Request a string response from the provided URL.
        StringRequest stringRequest = new StringRequest(Request.Method.GET, url,
                new Response.Listener<String>() {
                    @Override public void onResponse(String response) {
                        if (response.contains("true")) sayHello.setText("Okay :)");
                        else sayHello.setText("Hey "+ name + "!");
                    }
                }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
                sayHello.setText("Greetings, "+ error + "!");
            }
        });
        // Add the request to the RequestQueue.
        queue.add(stringRequest);
    }
}
