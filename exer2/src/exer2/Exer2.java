/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package exer2;

/**
 *
 * @author heart
 */
public class Exer2 {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        DBConnect a = new DBConnect();
        if ("Insert".equals(args[0])){
            a.insertData(args[1],args[2],args[3]);
        }else{
            a.getData(args[0]);
        }
    }
    
}