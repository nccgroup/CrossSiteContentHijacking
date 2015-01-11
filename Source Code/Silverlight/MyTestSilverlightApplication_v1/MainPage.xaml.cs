using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Animation;
using System.Windows.Shapes;
using System.Windows.Browser;

namespace ContentHijacking
{
    [ScriptableType]
    public partial class MainPage : UserControl
    {
        // Create the web client.
        WebClient webClient = new WebClient();
        private string jsCallback;

        public MainPage()
        {
            InitializeComponent();

            // Associate the web client with a handler for its
            // UploadStringCompleted event.
            webClient.DownloadStringCompleted +=
                new DownloadStringCompletedEventHandler(webClient_DownloadStringCompleted);

            webClient.UploadStringCompleted +=
                new UploadStringCompletedEventHandler(webClient_UploadStringCompleted);

  
       

            HtmlPage.RegisterScriptableObject("silverlightInterop", this);
        }

        private void button1_Click(object sender, RoutedEventArgs e)
        {
            // Sent the request to the specified URL.
            try
            {
                webClient.DownloadStringAsync(new Uri(textBoxTarget.Text, UriKind.Absolute));
            }catch(Exception err){
                textBoxResult.Text = "URL Error:" + err.Message;
            }
        }

        // Event handler for the UploadStringCompleted event.
        void webClient_DownloadStringCompleted(object sender, DownloadStringCompletedEventArgs e)
        {
            // Output the response. 
            if (e.Error != null)
                if (!e.Error.Message.Equals(""))
                {
                    textBoxResult.Text = e.Error.Message + "\r\n" + e.Error.StackTrace;
                    InvokeCallback_JSLogger(textBoxResult.Text);
                }
                else
                {
                    textBoxResult.Text = e.Error.InnerException.Message + "\r\n" + e.Error.InnerException.StackTrace;
                    InvokeCallback_JSLogger(textBoxResult.Text);
                }
            else
            {
                textBoxResult.Text = e.Result;
                InvokeCallback_JSLogger(textBoxResult.Text);
            }
        }

        private void webClient_UploadStringCompleted(object sender, UploadStringCompletedEventArgs e)
        {
            // Output the response. 
            if (e.Error != null)
                if (!e.Error.Message.Equals(""))
                {
                    textBoxResult.Text = e.Error.Message + "\r\n" + e.Error.StackTrace;
                    InvokeCallback_JSLogger(textBoxResult.Text);
                }
                else
                {
                    textBoxResult.Text = e.Error.InnerException.Message + "\r\n" + e.Error.InnerException.StackTrace;
                    InvokeCallback_JSLogger(textBoxResult.Text);
                }
            else
            {
                textBoxResult.Text = e.Result;
                InvokeCallback_JSLogger(textBoxResult.Text);
            }
        }

        [ScriptableMember]
        public void GETURL(string callback, string strURL)
        {
            jsCallback = callback;
            textBoxTarget.Text = strURL;
            try
            {
                webClient.DownloadStringAsync(new Uri(strURL, UriKind.Absolute));
            }
            catch (Exception err)
            {
                textBoxResult.Text = "URL Error:" + err.Message;
                InvokeCallback_JSLogger(textBoxResult.Text);
            }
        }

        [ScriptableMember]
        public void POSTURL(string callback, string strURL, string strPOSTData)
        {
            jsCallback = callback;
            textBoxTarget.Text = strURL;
            try
            {
                webClient.Headers["Content-type"] = "application/x-www-form-urlencoded";
                webClient.UploadStringAsync(new Uri(strURL, UriKind.Absolute), "POST", strPOSTData);
            }
            catch (Exception err)
            {
                textBoxResult.Text = "URL Error:" + err.Message;
                InvokeCallback_JSLogger(textBoxResult.Text);
            }
        }

        public void InvokeCallback_JSLogger(string strInput)
        {
            if (!string.IsNullOrEmpty(jsCallback))
            {
                System.Windows.Browser.HtmlPage.Window.Invoke(jsCallback, strInput);
            }
        }

        // For debugging!
        [ScriptableMember]
        public void ShowAlertPopup(string message)
        {
            MessageBox.Show(message, "Message From Silverlight in JavaScript", MessageBoxButton.OK);
        }
    }
}
