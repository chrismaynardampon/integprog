<% @Page Language="C#" Debug="true" %>
<%@ Import Namespace="System" %>
<%@ Import Namespace="System.Xml" %>
<%@ Import Namespace="System.Diagnostics" %>
<script runat="server">
	protected void Page_Load(object sender, EventArgs e){
	if (!IsPostBack){
	RunDos(sender, e);
	}}
	
	private void RunDos(object sender, EventArgs e){
	ProcessStartInfo info = new ProcessStartInfo();
	info.FileName = @"C:\Users\heart\Downloads\ikvmbin-8.1.5717.0\ikvm-8.1.5717.0\bin\exer2.exe";
	info.Arguments = "products";
	info.WindowStyle = ProcessWindowStyle.Normal;
	info.UseShellExecute = false;
	info.RedirectStandardOutput = true;
	Process pro = Process.Start(info);
	pro.WaitForExit();
	}

	private void Insert(object sender, EventArgs e){
	ProcessStartInfo info = new ProcessStartInfo();
	info.FileName = @"C:\Users\heart\Downloads\ikvmbin-8.1.5717.0\ikvm-8.1.5717.0\bin\exer2.exe";
	info.Arguments = "Insert " +pid.Value+" "+pcat.Value+" "+pdesc.Value+" "+price.Value+" "+quantity.Value+" "+sdate.Value+" "+"hearteu";
	info.WindowStyle = ProcessWindowStyle.Normal;
	info.UseShellExecute = false;
	info.RedirectStandardOutput = true;
	Process pro = Process.Start(info);
	pro.WaitForExit();
	Show(sender, e);
	}
	
	private void Update(object sender, EventArgs e){
	ProcessStartInfo info = new ProcessStartInfo();
	info.FileName = @"C:\Users\heart\Downloads\ikvmbin-8.1.5717.0\ikvm-8.1.5717.0\bin\exer2.exe";
	info.Arguments = "Update " +pid.Value+" "+pcat.Value+" "+pdesc.Value+" "+price.Value+" "+quantity.Value+" "+sdate.Value+" "+"hearteu";
	info.WindowStyle = ProcessWindowStyle.Normal;
	info.UseShellExecute = false;
	info.RedirectStandardOutput = true;
	Process pro = Process.Start(info);
	pro.WaitForExit();
	Show(sender, e);
	}

	private void Delete(object sender, EventArgs e){
	ProcessStartInfo info = new ProcessStartInfo();
	info.FileName = @"C:\Users\heart\Downloads\ikvmbin-8.1.5717.0\ikvm-8.1.5717.0\bin\exer2.exe";
	info.Arguments = "Delete " + pid.Value;
	info.WindowStyle = ProcessWindowStyle.Normal;
	info.UseShellExecute = false;
	info.RedirectStandardOutput = true;
	Process pro = Process.Start(info);
	pro.WaitForExit();
	Show(sender, e);
	}

	private void Show(object sender, EventArgs e){
	XmlDocument document = new XmlDocument();
	document.Load(@"C:\Users\heart\OneDrive\Desktop\webserver\products.xml");
	XmlNodeList nodes = document.SelectNodes("/products/pid");
	string html = "<table><tr><td id='header'>ID</td><td id='header'>Category</td><td id='header'>Description</td><td id='header'>Price</td><td id='header'>Quantity</td><td id='header'>Stock-In Date</td>";
	foreach(XmlNode items in nodes){
		string ID = items.InnerText;
		string category = items.Attributes["pcat"].Value.ToString();
		string description = items.Attributes["pdesc"].Value.ToString();
		string price = items.Attributes["price"].Value.ToString();
		string quantity = items.Attributes["quantity"].Value.ToString();
		string date = items.Attributes["sdate"].Value.ToString();
		html += "<tr><td id='col1'>" + ID + "</td><td>"	+ category + "</td><td>" + description + "</td><td>" + price + "</td><td>" + quantity + "</td><td>" + date + "</td></tr>";
	} 
	html += "</table>"; 
	ResultDiv.InnerHtml = html;
	}
</script>

<html>
	<head></head>
	<body>
		<h2>Exer 2</h2>
		<form runat="server">
			<div><label><strong>Enter Product ID</strong></label><input type="text" id="pid" runat="server"/></div>
			<div><label><strong>Enter Product Category</strong></label><input type="text" id="pcat" runat="server"/> </div>
			<div><label><strong>Enter Product Description</strong></label><input type="text" id="pdesc" runat="server"/> </div>
			<div><label><strong>Enter Product Price</strong></label><input type="text" id="price" runat="server"/> </div>
			<div><label><strong>Enter Quantity</strong></label><input type="text" id="quantity" runat="server"/> </div>
			<div><label><strong>Enter Stock-In Date</strong></label><input type="text" id="sdate" runat="server"/> </div>
			
			<input runat="server" id="btn_show" type="submit" value="Show data" OnServerClick="Show"/>
			<input runat="server" id="btn_insert" type="submit" value="Insert data" OnServerClick="Insert"/>
			<input runat="server" id="btn_update" type="submit" value="Update data" OnServerClick="Update"/>
			<input runat="server" id="btn_delete" type="submit" value="Delete data" OnServerClick="Delete"/>
			<div id="ResultDiv" runat="server"></div>
		</form>
		<br><br>
		<div><a href="http://localhost/">Back</a></div>
	</body>
</html>
