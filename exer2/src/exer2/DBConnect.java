/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package exer2;

import java.io.PrintWriter;
import java.sql.DriverManager;
import java.sql.*;
/**
 *
 * @author heart
 */
public class DBConnect {
    private Connection con;
    private Statement st;
    private ResultSet rs;
    
    public DBConnect(){
        try{
            Class.forName("com.mysql.jdbc.Driver");
             con = DriverManager.getConnection("jdbc:mysql://10.0.2.15:3306/exer2?zeroDateTimeBehavior=convertToNull","root","root");
            st = con.createStatement();
        }
        catch(Exception ex){
            System.out.println("Error; " + ex);
        }
    }
    
    public void insertData(String a, String b, String c){
        System.out.println("perform insert query");
    }
    
    public void getData(String a){
        PrintWriter writer;
        try{
            String query = "select * from products";
            rs = st.executeQuery(query);
            System.out.println("Records from Database");
            writer = new PrintWriter("C:\\Users\\heart\\OneDrive\\Desktop\\webserver\\" + a + ".xml","UTF-8");
            writer.println("<?xml version='1.0'?>");
            writer.println("<products>");
            while (rs.next()){
                String id = rs.getString("pid");
                String pcat = rs.getString("pcat");
                String pdesc = rs.getString("pdesc");
                String price = rs.getString("price");
                String quantity = rs.getString("quantity");
                String sdate = rs.getString("sdate");
                writer.println("<pid pcat= '"+pcat+"' pdesc= '"+pdesc+"' price= '"+price+"' quantity= '"+quantity+"' sdate= '"+sdate+"'>"+id+"</pid>");
                System.out.println("\n Product ID: "+id+"\n Product Category: "+pcat+"\n Product Description: "+pdesc+"\n Price: "+price+"\n Quantity: "+quantity+"\n Stock-In Date: "+sdate);
            }
            writer.println("</products>");
            writer.close();
        }
        catch (Exception ex){
            System.out.println(ex);
        }
    }
}
