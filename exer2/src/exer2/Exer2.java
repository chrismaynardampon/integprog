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
            a.insertData(args[1],args[2],args[3],args[4],args[5],args[6],args[7]);
        }
        else if("Update".equals(args[0])){
            a.updateData(args[1],args[2],args[3],args[4],args[5],args[6],args[7]);
        }
        else if("Delete".equals(args[0])){
            a.deleteData(args[1]);
        }
        else{
            a.getData(args[0]);
        }
    }
    
}
