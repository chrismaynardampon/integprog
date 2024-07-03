#!/usr/bin/perl
use strict;
use warnings;
use CGI qw(:standard);

use Inline Java => <<'END',CLASSPATH => 'A:\ADDU\3rd Year\exer4\mysql-connector-java-5.1.47.jar', AUTOSTUDY => 1;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
public class Products {
	String pid, pcat, pdesc, price, quantity, sdate;
	Connection con;
	Statement st;
	ResultSet rs;

public Products(){
	initialized();
	get_database();
}

public Products (String pid, String pcat, String pdesc, String price, String quantity, String sdate){
	this.pid = pid;
	this.pcat = pcat;
	this.pdesc = pdesc;
	this.price = price;
	this.quantity = quantity;
	this.sdate = sdate;
	initialized();
}
	
private void initialized(){
	try
	{
		Class.forName("com.mysql.jdbc.Driver");
		con = DriverManager.getConnection("jdbc:mysql://localhost:3306/testdb?zeroDateTimeBehavior=convertToNull", "root", "root");
		st = con.createStatement();
	}
	catch (Exception ex)
	{
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
            String query = "insert into products values (' ','" + category +"',' ',' ',' ',' ',' ')";
            con.createStatement().executeUpdate(query);
        }
        catch(Exception ex){
            System.out.println(ex);
           
        }
    }

public String insertData(){
	try
	{
		String query ="insert into products values('"+this.pid+"','"+this.pcat+"','"+this.pdesc+"','"+this.price+"','"+this.quantity+"','"+this.sdate+"','hatdog')";
		st.executeUpdate(query);
	}
	catch (Exception ex)
	{
		System.out.println(ex);
	}
	return "Inserted";
}

public String updateData(){
	try
	{
		if (this.pid == null || this.pid.isEmpty()){this.pid = " ";}
		String query = "update products set pid='"+this.pid+"', pdesc='" + this.pdesc + "', price='" + this.price + "', quantity='" + this.quantity + "', sdate='" + this.sdate + "' where pid='" + this.pid + "' and pcat='"+this.pcat+"'";
		st.executeUpdate(query);
	}
	catch (Exception ex)
	{
		System.out.println(ex);
	}
	return "Updated";
}

public String deleteData(){
	try
	{
		String query = "delete from products where pid='" + this.pid + "' and pcat='"+this.pcat+"'";
		st.executeUpdate(query);
	}
	catch (Exception ex)
	{
		System.out.println(ex);
	}
	return "Deleted";
}



public String[][] selectAllProducts(){
	String [][] resultArray = new String[0][];
	try
	{
		String query = "select * from products";
		rs = st.executeQuery(query);
		rs.last();
		int rowCount = rs.getRow();
		rs.beforeFirst();
		resultArray = new String[rowCount][6];
		int rowindex = 0;
		while (rs.next()){
			resultArray[rowindex][0] = rs.getString("pid");
			resultArray[rowindex][1] = rs.getString("pcat");
			resultArray[rowindex][2] = rs.getString("pdesc");
			resultArray[rowindex][3] = rs.getString("price");
			resultArray[rowindex][4] = rs.getString("quantity");
			resultArray[rowindex][5] = rs.getString("sdate");
			rowindex++;
		}
	}
	catch (SQLException ex)
	{
		System.out.println("Error executing query: " + ex);
	}
	return resultArray;
}

}
END

my $cgi = CGI->new;

my $action = $cgi->param('action')||'';
my $pid = $cgi->param('pid')||0;
my $pcat = $cgi->param('pcat')||'';
my $pdesc = $cgi->param('pdesc')||'';
my $price = $cgi->param('price')||'';
my $quantity = $cgi->param('quantity')||'';
my $sdate = $cgi->param('sdate')||'';

print $cgi->header();
print $cgi->start_html('Exer 5');
print $cgi->h1('Exer 5');

print qq(
	<form method="POST" action="">
		Product ID: <input type="text" name="product-id" value="$pid"><br>
		Product Category: <input type="text" name="product-category" value="$pcat"><br>
		Product Description: <input type="text" name="product-description" value="$pdesc"><br>
		Price <input type="text" name="price" value="$price"><br>
		Quantity: <input type="text" name="quantity" value="$quantity"><br>
		Stock-In Date: <input type="text" name="sdate" value="$sdate"><br>
		<input type="submit" value="Add">
		<input type="submit" value="Update">
		<input type="submit" value="Delete">
	</form>
)

