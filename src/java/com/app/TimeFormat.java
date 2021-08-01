/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.app;

import java.util.HashMap;


public class TimeFormat {
    public HashMap<Integer, String> timeConvert = new HashMap<Integer, String>();
    public TimeFormat(){
        for(int i=0; i<=23; i++){
            if(i == 0){
                this.timeConvert.put(i, 12+":00 AM");
            }
            else if(i<12){
                this.timeConvert.put(i, i+":00 AM");
            }
            else if(i==12){
                this.timeConvert.put(i, i+":00 PM");
            }
            else{
                this.timeConvert.put(i, i%12+":00 PM");
            }
        }
    }
}
