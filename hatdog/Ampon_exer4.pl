use strict;
use warnings;
use Tk;
use Inline Java => <<'END',CLASSPATH => 'C:\Users\heart\Downloads\hatdog\mysql-connector-java-5.1.47.jar', AUTOSTUDY => 1;
import java.sql.*;
public class Products {
	String pid, pcat, pdesc, price, quantity, sdate;
	Connection con;
	Statement st;
	ResultSet rs;

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
my $obj = new Products("1", "asd","asd","asd","asd","asd");
print($obj->insertData()."\n");
my $resultArray = $obj->selectAllProducts();
foreach my $row (@$resultArray){
	my($pid,$pcat,$pdesc,$price,$quantity,$sdate) = @$row;
	print"Product ID: $pid, Product Category: $pcat, Product Description: $pdesc, Price: $price, Quantity: $quantity, Stock-In Date: $sdate";
}

my $mw = MainWindow->new;
$mw ->geometry("1000x1000");

$mw->title("Product Records");

my $frame = $mw->Frame()->pack(-side => 'top',-fill=>'both',-expand=>1);
my $scroll = $frame->Scrollbar();
my $listbox = $frame->Listbox(
	-yscrollcommand => ['set',$scroll],
	-font => 'Courier 12'
);
$scroll->configure(-command=>['yview',$listbox]);

$scroll->pack(-side=>'right',-fill=>'y');
$listbox->pack(-side=>'right',-fill=>'both', -expand=>1);

#Insert column headers
$listbox->insert('end',sprintf("%-10s %-30s %-20s %-10s %-10s", "Product ID", "Product Description", "Price", "Quantity", "Stock-In Date"));
$listbox->insert('end',"-" x 70);
MainLoop;