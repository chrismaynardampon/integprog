<% @Page Language="C#" Debug="true" %>
<%@ Import Namespace="System" %>
<%@ Import Namespace="System.Xml" %>
<script runat="server">
    private void UpdatePrice(object sender, EventArgs e)
    {
        // Get the price from the XML file
        XmlDocument document = new XmlDocument();
        document.Load(@"C:\Users\heart\OneDrive\Desktop\webserver\Books.xml");
        XmlNodeList userNodes = document.SelectNodes("//bookstore/book");
        foreach (XmlNode userNode in userNodes)
        {
            float price = float.Parse(userNode.Attributes["price"].Value);
            userNode.Attributes["price"].Value = (price * 1).ToString();
        }
        document.Save(@"C:\Users\heart\OneDrive\Desktop\webserver\Books.xml");
    }

    private void ShowFname(object sender, EventArgs e)
    {
        XmlDocument document = new XmlDocument();
        document.Load(@"C:\Users\heart\OneDrive\Desktop\webserver\Books.xml");
        XmlNodeList nodes = document.SelectNodes("/bookstore/book/author/first-name");
        foreach (XmlNode item in nodes)
        {
            string res = item.InnerText;
            Response.Write(res + "<br>");
        }
    }

    private void InsertFname(object sender, EventArgs e)
    {
        XmlDocument document = new XmlDocument();
        document.Load(@"C:\Users\heart\OneDrive\Desktop\webserver\Books.xml");
        XmlNode root = document.DocumentElement;
        XmlElement elem = document.CreateElement("book");
        elem.SetAttribute("genre", "action");
        root.AppendChild(elem);
        elem.SetAttribute("price", "11.11");
        root.AppendChild(elem);
        XmlElement titlenode = document.CreateElement("title");
        titlenode.InnerText = "Avengers";
        elem.AppendChild(titlenode);
        document.Save(@"C:\Users\heart\OneDrive\Desktop\webserver\Books.xml");
    }
</script>
<!-- Layout -->
<html>
    <body>
        <form runat="server">
            <input runat="server" id="btn1" type="submit" value="View" OnServerClick="ShowFname"/>
            <input runat="server" id="btn2" type="submit" value="Update" OnServerClick="UpdatePrice"/>
            <input runat="server" id="btn3" type="submit" value="Insert" OnServerClick="InsertFname"/>
        </form>
    </body>
</html>