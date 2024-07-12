using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Xml;
using exer3;
using IronPython.Hosting;
using Microsoft.Scripting.Hosting;
using static System.Windows.Forms.VisualStyles.VisualStyleElement;

namespace Ampon_Exer3
{
    public partial class Form_Exer3 : Form
    {
        public Exer3 a = new Exer3();
        public Form_Exer3()
        {
            InitializeComponent();
            LoadCategory();
            string[][] data = a.getData();
            DisplayDataInListView(data);
            xmlPython();
        }

        private void Form1_Load(object sender, EventArgs e)
        {

        }

        private void LoadCategory()
        {
            try
            {
                var databases = a.get_database().Split('/');
                cbox_category.Items.Clear();

                foreach (string db in databases)
                {
                    cbox_category.Items.Add(db);
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error: " + ex.Message);
            }
        }

        private void textBox2_TextChanged(object sender, EventArgs e)
        {

        }

        private void txt_pid_TextChanged(object sender, EventArgs e)
        {

        }

        private void btn_insert_Click(object sender, EventArgs e)
        {
            string pid = txt_pid.Text;
            string pcat = cbox_category.SelectedItem.ToString();
            string pdesc = txt_pdesc.Text;
            string price = txt_price.Text;
            string quantity = txt_quantity.Text;
            string sdate = txt_sdate.Text;
            a.insert_products(pid, pcat, pdesc, price, quantity, sdate);

                if (!string.IsNullOrEmpty(pcat))
                {
                    string[][] data = a.getData(pcat);
                    DisplayDataInListView(data);
                    xmlPython();
            }
        }

        private void cbox_category_SelectedIndexChanged(object sender, EventArgs e)
        {
            string selectedCategory = cbox_category.SelectedItem.ToString();
            if (!string.IsNullOrEmpty(selectedCategory))
            {
                string[][] data = a.getData(selectedCategory);
                DisplayDataInListView(data);
            }
            else {
                string[][] data = a.getData();
                DisplayDataInListView(data);
            }
        }
        private void DisplayDataInListView(string[][] data)
        {
            listView_products.Items.Clear();
            listView_products.Columns.Clear();
            listView_products.View = View.Details;
            listView_products.Columns.Add("Product ID");
            listView_products.Columns.Add("Description");
            listView_products.Columns.Add("Price");
            listView_products.Columns.Add("Quantity");
            listView_products.Columns.Add("Stock-In Date");

            foreach (var row in data)
            {
                ListViewItem item = new ListViewItem(row);
                listView_products.Items.Add(item);
            }
        }

        private void btn_newCategory_Click(object sender, EventArgs e)
        {
            string newCategory = cbox_category.Text;

            if (!string.IsNullOrEmpty(newCategory))
            {
                a.insert_category(newCategory);
                LoadCategory();
                xmlPython();
            }
        }

        private void listView_products_Click(object sender, EventArgs e)
        {
            if (listView_products.SelectedItems.Count > 0)
            {
                ListViewItem selectedItem = listView_products.SelectedItems[0];
                string pid = selectedItem.SubItems[0].Text;
                string pdesc = selectedItem.SubItems[1].Text;
                string price = selectedItem.SubItems[2].Text;
                string quantity = selectedItem.SubItems[3].Text;
                string sdate = selectedItem.SubItems[4].Text;

                txt_pid.Text = pid;
                txt_pdesc.Text = pdesc;
                txt_price.Text = price;
                txt_quantity.Text = quantity;
                txt_sdate.Text = sdate;

            }
        }

        private void btn_update_Click(object sender, EventArgs e)
        {
            string pid = txt_pid.Text;
            string pcat = cbox_category.SelectedItem.ToString();
            string pdesc = txt_pdesc.Text;
            string price = txt_price.Text;
            string quantity = txt_quantity.Text;
            string sdate = txt_sdate.Text;
                a.update_products(pid, pdesc, price, quantity, sdate);

                if (!string.IsNullOrEmpty(pcat))
                {
                    string[][] data = a.getData(pcat);
                    DisplayDataInListView(data);
                    xmlPython();
            }
        }

        private void btn_delete_Click(object sender, EventArgs e)
        {
            string pid = txt_pid.Text;
            string pcat = cbox_category.SelectedItem.ToString();

                a.delete_products(pid,pcat);
                if (!string.IsNullOrEmpty(pcat))
                {
                    string[][] data = a.getData(pcat);
                    DisplayDataInListView(data);
                    LoadCategory();
                    xmlPython();
                }
            
        }

        private void xmlPython() {
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
            document.Save(@"C:\webserver\products.xml");
        }
    }
}
