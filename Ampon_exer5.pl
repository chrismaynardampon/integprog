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
	return null;
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

public void insertData(){
	try
	{
		String query ="insert into products values('"+this.pid+"','"+this.pcat+"','"+this.pdesc+"','"+this.price+"','"+this.quantity+"','"+this.sdate+"','hatdog')";
		st.executeUpdate(query);
	}
	catch (Exception ex)
	{
		System.out.println(ex);
	}
}

public void updateData(){
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
}

public void deleteData(){
	if (this.pid == null || this.pid.isEmpty()){this.pid = " ";}
	try
	{
		String query = "delete from products where pid='" + this.pid + "' and pcat='"+this.pcat+"'";
		st.executeUpdate(query);
	}
	catch (Exception ex)
	{
		System.out.println(ex);
	}
}



public String[][] selectAllProducts() {
        List<String[]> products = new ArrayList<>();
        try {
            String query = "select pid,pdesc,price,quantity,sdate from products";
            rs = st.executeQuery(query);
            while (rs.next()) {
                String[] product = new String[6];
                product[0] = rs.getString("pid");
                product[1] = rs.getString("pdesc");
                product[2] = rs.getString("price");
                product[3] = rs.getString("quantity");
                product[4] = rs.getString("sdate");
                products.add(product);
            }
        } catch (SQLException ex) {
            System.out.println("Error executing query: " + ex);
        }
        return products.toArray(new String[0][0]);
}

}
END


my $cgi = CGI->new;

my $action = $cgi->param('action') || '';
my $pid = $cgi->param('pid') || '';
my $pcat = $cgi->param('pcat') || '';
my $pdesc = $cgi->param('pdesc') || '';
my $price = $cgi->param('price') || '';
my $quantity = $cgi->param('quantity') || '';
my $sdate = $cgi->param('sdate') || '';

print $cgi->header();
print $cgi->start_html(
    -title => 'Exer 5',
    -style => {
        -code => '
            body {
                font-family: Arial, sans-serif;
                margin: 20px;
            }
            form {
                margin-bottom: 20px;
            }
            input[type="text"], select, datalist {
                margin-bottom: 10px;
                padding: 8px;
                width: 300px;
                border: 1px solid #ccc;
                border-radius: 4px;
            }
	    input[type="submit"]:hover, input[type="button"]:hover {
                background-color: #45a049;
            }
            .button {
                padding: 10px 20px;
                background-color: gray;
                color: white;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                margin-right: 10px;
            }
            .button.selected {
                background-color: #4CAF50;
            }
            table {
                width: 100%;
                border-collapse: collapse;
            }
            table, th, td {
                border: 1px solid black;
            }
            th, td {
                padding: 12px;
                text-align: left;
            }
            th {
                background-color: #f2f2f2;
            }
        '
    },
    -script => [
        {
            -code => '
                document.addEventListener("DOMContentLoaded", function() {
                    var buttons = document.querySelectorAll(".button");
                    buttons.forEach(function(button) {
                        button.addEventListener("click", function() {
                            buttons.forEach(function(btn) {
                                btn.classList.remove("selected");
                            });
                            button.classList.add("selected");
                        });
                    });
                });
            '
        }
    ]
);

print $cgi->h1('Exer 5');

my $product = Products->new();
my $categories_string = $product->get_database();
my @categories = split('/', $categories_string);

# Check if the new category form was submitted
my $new_category = $cgi->param('new_category');
if ($new_category) {
    # Handle adding new category to the database
    $product->insert_category($new_category);
    # Set $pcat to the newly added category
    $pcat = $new_category;
}

print qq(
    <form method="POST" action="">
        Product ID: <input type="text" name="pid" value="$pid"><br>
        Product Category: 
        <input list="categoriesList" name="pcat" value="$pcat">
        <datalist id="categoriesList">
);

foreach my $category (@categories) {
    print qq(<option value="$category">);
}

print qq(
        </datalist><br>
        Product Description: <input type="text" name="pdesc" value="$pdesc"><br>
        Price: <input type="text" name="price" value="$price"><br>
        Quantity: <input type="text" name="quantity" value="$quantity"><br>
        Stock-In Date: <input type="text" name="sdate" value="$sdate"><br>
        <input type="submit" class="button" name="action" value="Show Data">
        <input type="submit" class="button" name="action" value="Insert">
        <input type="submit" class="button" name="action" value="Update">
        <input type="submit" class="button" name="action" value="Delete">
	<input type="submit" class="button" name="action" value="Add Category">
	<input type="submit" class="button" name="action" value="Show Category">
    </form>

    <script>
        // Set the value of the input based on $pcat
        document.getElementsByName('pcat')[0].value = "$pcat";
    </script>
);

print $cgi->end_html;

my $product = Products->new($pid, $pcat, $pdesc, $price, $quantity, $sdate);
my $data = $product->getData();
if ($action eq 'Insert') {
    print $product->insertData();
    $data = $product->getData($pcat);
    ShowData();
} elsif ($action eq 'Update') {
    print $product->updateData();
    ShowData();
} elsif ($action eq 'Delete') {
    print $product->deleteData();
    $data = $product->getData($pcat);
    ShowData();
} elsif ($action eq 'Show Data') {
    ShowData();
} elsif ($action eq 'Add Category') {
    print $product->insert_category($pcat);
    $data = $product->getData($pcat);
    ShowData();
} elsif ($action eq 'Show Category') {
    $data = $product->getData($pcat);
    ShowData();
}

sub ShowData {
    print "<table>";
    print "<tr><th>Product ID</th><th>Description</th><th>Price</th><th>Quantity</th><th>Stock-In Date</th></tr>";
    foreach my $row (@$data) {
        print "<tr>";
        foreach my $col (@$row) {
            print "<td>$col</td>";
        }
        print "</tr>";
    }
    print "</table>";
}