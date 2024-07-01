use strict;
use warnings;
use Tk;
use Tk::BrowseEntry;
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
# my $obj = new Products("1", "asd","asd","asd","asd","asd");
# print($obj->insertData()."\n");
# my $resultArray = $obj->selectAllProducts();
#foreach my $row (@$resultArray){
#	my($pid,$pcat,$pdesc,$price,$quantity,$sdate) = @$row;
#	print"Product ID: $pid, Product Category: $pcat, Product Description: $pdesc, Price: $price, Quantity: $quantity, Stock-In Date: # # $sdate";}

my $obj = new Products();
my $resultArray = $obj->selectAllProducts();

my $mw = MainWindow->new;
$mw ->geometry("1000x700");

$mw->title("Product Records");

my $frame = $mw->Frame()->pack(-side => 'left',-fill=>'both',-expand=>1);
my $scroll = $frame->Scrollbar();
my $listbox = $frame->Listbox(
	-yscrollcommand => ['set',$scroll],
	-font => 'Courier 12'
);
$scroll->configure(-command=>['yview',$listbox]);

$scroll->pack(-side=>'right',-fill=>'y');
$listbox->pack(-side=>'right',-fill=>'both', -expand=>2);

# Insert column headers
$listbox->insert('end',sprintf("%-10s %-20s %-10s %-10s %-10s", "Product ID", "Product Description", "Price", "Quantity", "Stock-In Date"));
$listbox->insert('end',"-" x 70);

# Display the records in the listbox
foreach my $row (@$resultArray){
	my($pid,$pcat,$pdesc,$price,$quantity,$sdate) = @$row;
	$listbox->insert('end',sprintf("%-10s %-20s %-10s %-10s %-10s", $pid,$pdesc,$price,$quantity,$sdate));
}

my $pcat_value = '';
my $cbox_pcat = $mw->BrowseEntry(
	-label =>"Select Category",
	-variable => \$pcat_value,
	-command => sub{
		my ($cbox_pcat) = @_;
		refresh_listbox($listbox, $obj);
	},
);

$cbox_pcat->pack();

my $label_pid = $mw->Label(-text=>"Product ID")->pack();
my $ent_pid = $mw-> Entry()->pack();
my $label_pdesc = $mw->Label(-text=>"Product Description")->pack();
my $ent_pdesc = $mw-> Entry()->pack();
my $label_price = $mw->Label(-text=>"Price")->pack();
my $ent_price = $mw-> Entry()->pack();
my $label_quantity = $mw->Label(-text=>"Quantity")->pack();
my $ent_quantity = $mw-> Entry()->pack();
my $label_sdate = $mw->Label(-text=>"Stock-In Date")->pack();
my $ent_sdate = $mw-> Entry()->pack();

# Buttons for New Category, Add, Update, Delete

my $frame_buttons = $mw->Frame()->pack(-side=>'right',-fill=>'x');

my $btn_category = $mw->Button(
	-text => "New Category",
	-command => sub{
		# get the value of the input_box
		my $pid = $ent_pid->get();
		my $pcat = $pcat_value;
		my $pdesc = $ent_pdesc->get();
		my $price = $ent_price->get();
		my $quantity = $ent_quantity->get();
		my $sdate = $ent_sdate->get();
		my $obj = new Products($pid,$pcat,$pdesc,$price,$quantity,$sdate);
		$obj->insert_category($pcat);
		LoadCategory();
		refresh_listbox($listbox, $obj);
	}
)->pack(-side=>'right',-padx=>10);

my $btn_add = $frame_buttons->Button(
	-text => "Add",
	-command => sub{
		# get the value of the input_box
		my $pid = $ent_pid->get();
		my $pcat = $pcat_value;
		my $pdesc = $ent_pdesc->get();
		my $price = $ent_price->get();
		my $quantity = $ent_quantity->get();
		my $sdate = $ent_sdate->get();
		my $obj = new Products($pid,$pcat,$pdesc,$price,$quantity,$sdate);
		$obj->insertData();
		LoadCategory();
		refresh_listbox($listbox, $obj);
	}
)->pack(-side=>'left',-padx=>10);

my $btn_update = $frame_buttons->Button(
	-text => "Update",
	-command => sub{
		my $pid = $ent_pid->get();
		my $pcat = $pcat_value;
		my $pdesc = $ent_pdesc->get();
		my $price = $ent_price->get();
		my $quantity = $ent_quantity->get();
		my $sdate = $ent_sdate->get();
		my $obj = new Products($pid,$pcat,$pdesc,$price,$quantity,$sdate);
		$obj->updateData();
		LoadCategory();
		refresh_listbox($listbox, $obj);
	}
)->pack(-side=>'left',-padx=>10);

my $btn_delete = $frame_buttons->Button(
	-text => "Delete",
	-command => sub{
		my $pid = $ent_pid->get();
		my $pcat = $pcat_value;
		my $pdesc = $ent_pdesc->get();
		my $price = $ent_price->get();
		my $quantity = $ent_quantity->get();
		my $sdate = $ent_sdate->get();
		my $obj = new Products($pid,$pcat,$pdesc,$price,$quantity,$sdate);
		$obj->deleteData();
		LoadCategory();
		refresh_listbox($listbox, $obj);
	}
)->pack(-side=>'left',-padx=>10);

# Function to refresh the listbox with updated data
sub refresh_listbox{
	my ($listbox, $obj) = @_;
	$listbox->delete(0,'end');

	# Insert column headers
	$listbox->insert('end',sprintf("%-10s %-20s %-10s %-10s %-10s", "Product ID", "Product Description", "Price", "Quantity", "Stock-In Date"));
	$listbox->insert('end',"-" x 70);
	
	my $resultArray = $obj->getData($pcat_value);	

	# Display the records in the listbox
	foreach my $row (@$resultArray){
		my($pid,$pdesc,$price,$quantity,$sdate) = @$row;
		$listbox->insert('end',sprintf("%-10s %-20s %-10s %-10s %-10s", $pid,$pdesc,$price,$quantity,$sdate));
	}

}

# Event handler for Listbox click
$listbox->bind('<<ListboxSelect>>', sub {
    my @selection_index = $listbox->curselection();
    if (@selection_index) {
        my $selected_index = $selection_index[0];
        my $selected_item = $listbox->get($selected_index);

	my ($pid, $pdesc, $price, $quantity, $sdate) = $selected_item =~ /^\s*(\S+)\s+(.+?)\s+(\S+)\s+(\S+)\s+(\S+)\s*$/;
	
        $ent_pid->delete(0, 'end');
	if ($pdesc eq ' '){$ent_pid->insert(0, '');$ent_pdesc->delete(0, 'end');
        $ent_pdesc->insert(0, $pid);}
	else{$ent_pid->insert(0, $pid); $ent_pdesc->delete(0, 'end');
        $ent_pdesc->insert(0, $pdesc);}

        $ent_price->delete(0, 'end');
        $ent_price->insert(0, $price);

        $ent_quantity->delete(0, 'end');
        $ent_quantity->insert(0, $quantity);

        $ent_sdate->delete(0, 'end');
        $ent_sdate->insert(0, $sdate);
    }
});

sub LoadCategory {
    eval {
	my $obj = new Products();
        my @databases = split('/', $obj->get_database());
        $cbox_pcat->delete(0, 'end');  # Clear existing items
	$cbox_pcat->insert('end', '');
        foreach my $db (@databases) {
            $cbox_pcat->insert('end', $db);  # Add new items
        }
	
    };
    if ($@) {
        print "Error: $@\n";
    }
}

LoadCategory();

MainLoop();

