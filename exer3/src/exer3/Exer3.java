/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package exer3;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
/**
 *
 * @author heart
 */
public class Exer3 {
    private Connection con;
    private Statement st;
    private ResultSet rs;
    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        // TODO code application logic here
    }
    
    public Exer3(){
        try{
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/testdb?zeroDateTimeBehavior=convertToNull","root","root");
            st = con.createStatement();
        }
        catch(Exception ex){
            System.out.println("Error: " + ex);
        }
        
    }
    
    public Exer3(String db){
        try{
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/"+ db +"?zeroDateTimeBehavior=convertToNull","root","root");
            st = con.createStatement();
        }
        catch(Exception ex){
            System.out.println("Error: " + ex);
        }
    }
    
    public String get_database(){
        try{
            String query = "select distinct pcat from products;";
            rs = st.executeQuery(query);
            String categories = "";
            while(rs.next()){
                categories += rs.getString("pcat") + "/";
            }
            return categories;
        }
        catch(Exception ex){
            System.out.println(ex);
            return null;
        }
    }
   
       
    public String[][] getData(){
        return getData(null);
    }

    public String[][] getData(String category){
        List<String[]> products = new ArrayList<>();
        try{
            String query;
            if (category == null || category.isEmpty()) {
                query = "select pid, pdesc, price, quantity, sdate from products";
            } else {
                query = "select pid, pdesc, price, quantity, sdate from products where pcat='" + category + "'";
            }
            rs = st.executeQuery(query);
            while (rs.next()){
                String[] product = new String[5];
                product[0] = rs.getString("pid");
                product[1] = rs.getString("pdesc");
                product[2] = rs.getString("price");
                product[3] = rs.getString("quantity");
                product[4] = rs.getString("sdate");
                products.add(product);
            }
        }
        catch(Exception e){
            System.out.println("Error:" + e);
        }
        return products.toArray(new String[0][0]);
    }

    public void insert_category(String category){
        try{
            String query = "insert into products (pid, pcat, pdesc, price, quantity, sdate) values ('','" + category +"','','','','')";
            con.createStatement().executeUpdate(query);
        }
        catch(Exception ex){
            System.out.println(ex);
           
        }
    }
    
     public void insert_products(String pid, String pcat, String pdesc, String price, String quantity, String sdate){
        try{
            String query = "insert into products (pid, pcat, pdesc, price, quantity, sdate) VALUES ('"+pid+"','"+pcat+"', '"+pdesc+"', '"+price+"', '"+quantity+"', '"+sdate+"');";
            con.createStatement().executeUpdate(query);
        }
        catch(Exception ex){
            System.out.println(ex);
           
        }
    }
    
    public void update_products(String pid, String pdesc, String price, String quantity, String sdate){
        try{
            String query = "update products set pdesc='" + pdesc + "', price='" + price + "', quantity='" + quantity + "', sdate='" + sdate + "' where pid='" + pid + "'";
            con.createStatement().executeUpdate(query);
        }
        catch(Exception ex){
            System.out.println(ex);
           
        }
    }
    
    public void delete_products(String pid){
        try{
            String query = "delete from products where pid='" + pid + "'";
            con.createStatement().executeUpdate(query);
        }
        catch(Exception ex){
            System.out.println(ex);  
        }
    }
    
}
