<%@ Page Language="C#" Debug="true" %>
<%@ Import Namespace="System" %>
<%@ Import Namespace="System.Xml" %>
<%@ Import Namespace="IronPython.Hosting" %>
<%@ Import Namespace="Microsoft.Scripting.Hosting" %>
<%@ Import Namespace="MySql.Data.MySqlClient" %>

<form id="form1" runat="server">
    <div>
        <h2>Exer 1</h2>
        <button type="submit" id="Button1" runat="server" onserverclick="Button1_Click">Fetch Data</button>
        </br></br>
        <div id="ResultDiv" runat="server"></div>
    </div>
    <div><a href="http://localhost/">Back</a></div>
</form>

<script runat="server">
    protected void Button1_Click(object sender, EventArgs e)
    {
        ScriptEngine engine = Python.CreateEngine();
        ScriptScope scope = engine.CreateScope();
        string pythonScript = @"
import clr
clr.AddReference('MySql.Data')
from MySql.Data.MySqlClient import MySqlConnection, MySqlCommand

def fetch_data():
    conn_str = 'server=localhost;user=root;database=testdb;port=3306;password=root'
    conn = MySqlConnection(conn_str)
    conn.Open()
    query = '''
    SELECT CONCAT(
        '<products>', 
        GROUP_CONCAT(
            CONCAT(
                '<product>',
                    '<pid>', pid, '</pid>',
                    '<pcategory>', pcat, '</pcategory>',
                    '<pdesc>', pdesc, '</pdesc>',
                    '<price>', price, '</price>',
                    '<stock_quantity>', quantity, '</stock_quantity>',
                    '<stock_in_date>', sdate, '</stock_in_date>',
                    '<picture>', picture, '</picture>',
                '</product>'
            ) SEPARATOR ''
        ),
        '</products>'
    ) AS xmloutput 
    FROM products;
    '''
    cmd = MySqlCommand('SET SESSION group_concat_max_len = 10000;', conn)
    cmd.ExecuteNonQuery()
    cmd = MySqlCommand(query, conn)
    reader = cmd.ExecuteReader()
    result = ''
    while reader.Read():
        result = reader.GetString(0)
    reader.Close()
    conn.Close()
    return result

data = fetch_data()
";

        ScriptSource source = engine.CreateScriptSourceFromString(pythonScript);
        source.Execute(scope);

        dynamic data = scope.GetVariable("data");

        XmlDocument document = new XmlDocument();
        document.LoadXml(data);

        string html = "<table border='1'><tr><th>ID</th><th>Category</th><th>Description</th><th>Price</th><th>Quantity</th><th>Stock-In-Date</th><th>Picture</th></tr>";

        XmlNodeList products = document.SelectNodes("//product");
        foreach (XmlNode product in products)
        {
            string id = product["pid"].InnerText;
            string category = product["pcategory"].InnerText;
            string description = product["pdesc"].InnerText;
            string price = product["price"].InnerText;
            string quantity = product["stock_quantity"].InnerText;
            string stockDate = product["stock_in_date"].InnerText;
            string picture = product["picture"].InnerText;

           html += "<tr><td>"+id+"</td><td>"+category+"</td><td>"+description+"</td><td>"+price+"</td><td>"+quantity+"</td><td>"+stockDate+"</td><td><img src=" + "\\pics\\" + picture + " style='height: 100px; width: 100px;'></td></tr>";
        }
        html += "</table>";
        ResultDiv.InnerHtml = html;

        document.Save(@"C:\Users\heart\OneDrive\Desktop\webserver\products.xml");
    }
</script>
