Cross-Site Content Hijacking (XSCH) PoC
=======================================
License
-------
Released under AGPL (see LICENSE for more information).

Description
-----------
This project can be used for:
- Exploiting websites with insecure policy files (crossdomain.xml or clientaccesspolicy.xml) by reading their contents.
- Exploiting insecure file upload functionalities which do not check the file contents properly or allow to upload SWF or PDF files without having Content-Disposition header during the download process. In this scenario, the created SWF, XAP, or PDF file should be uploaded with any extension such as .JPG to the target website. Then, the "Object File" value should be set to the URL of the uploaded file to read the target website's contents.
Note: .XAP files can be renamed to any other extension but they cannot be load cross-domain anymore. It seems Silverlight finds the file extension based on the provided URL and ignores it if it is not .XAP. This can still be exploited if a website allows users to use ";" or "/" after the actual file name to add a ".XAP" extension.


Usage
-----
- Exploiting an insecure policy file:
  1) Host the ContentHijacking directory with a web server.
  2) Browse to the ContentHijacking.html page.
  3) Change the target in the HTML page to a suitable object from the "objects" directory ("xfa-manual-ContentHijacking.pdf" cannot be used).
- Exploiting an insecure file upload/download: 
  1) Upload an object file from the "objects" directory to the victim server. These files can also be renamed with another extension when uploaded to another domain (for this purpose, first use Flash and then PDF as Silverlight XAP files will not normally work with another extension from another domain).
  2) Change the target in the HTML page to the location of the uploaded file.

Note: .XAP files can be renamed to any other extension but they cannot be load cross-domain anymore. It seems Silverlight finds the file extension based on the provided URL and ignores it if it is not .XAP. This can still be exploited if a website allows users to use “;” or “/” after the actual file name to add a “.XAP” extension.

Note: When Silverlight requests a .XAP file cross-domain, the content type must be: application/x-silverlight-app.

Note: PDF files can only be used in Adobe Reader viewer (they will not work with Chrome and Firefox built-in PDF viewers)

Generic Recommendation to Solve the Security Issue
--------------------------------------------------
The file types allowed to be uploaded should be restricted to only those that are necessary for business functionality.
* The application should perform filtering and content checking on any files which are uploaded to the server. Files should be thoroughly scanned and validated before being made available to other users. If in doubt, the file should be discarded.

Adding “Content-Disposition: Attachment” header to static files will secure the website against Flash/PDF-based cross-site content hijacking attacks. It is recommended to perform this practice for all of the files that users need to download in all the modules that deal with a file download. Although this method does not secure the website against attacks by using Silverlight or similar objects, it can mitigate the risk of using Adobe Flash and PDF objects especially when uploading PDF files is permitted.

Flash/PDF (crossdomain.xml) or Silverlight (clientaccesspolicy.xml) cross-domain policy files should be removed if they are not in use and there is no business requirement for Flash or Silverlight applications to communicate with the website.

Cross-domain access should be restricted to a minimal set of domains that are trusted and will require access. An access policy is considered weak or insecure when a wildcard character is used especially in the value of the “uri” attribute.

Any "crossdomain.xml" file which is used for Silverlight applications should be considered weak as it can only accept a wildcard (“*”) character in the domain attribute.

Browser caching should be disabled for the corssdomain.xml and clientaccesspolicy.xml files. This enables the website to easily update the file or restrict access to the Web services if necessary. Once the client access policy file is checked, it remains in effect for the browser session so the impact of non-caching to the end-user is minimal. This can be raised as a low or informational risk issue based on the content of the target website and security and complexity of the policy file(s).

References
----------
Even uploading a JPG file can lead to Cross Domain Data Hijacking (client-side attack)!
https://soroush.secproject.com/blog/2014/05/even-uploading-a-jpg-file-can-lead-to-cross-domain-data-hijacking-client-side-attack/

Multiple PDF Vulnerabilities - Text and Pictures on Steroids
http://insert-script.blogspot.co.at/2014/12/multiple-pdf-vulnerabilites-text-and.html

HTTP Communication and Security with Silverlight
http://msdn.microsoft.com/en-gb/library/cc838250(v=vs.95).aspx

Explanation Of Cross Domain And Client Access Policy Files For Silverlight
http://www.devtoolshed.com/explanation-cross-domain-and-client-access-policy-files-silverlight

Cross-domain policy file specification
http://www.adobe.com/devnet/articles/crossdomain_policy_file_spec.html

Setting a crossdomain.xml file for HTTP streaming
http://www.adobe.com/devnet/adobe-media-server/articles/cross-domain-xml-for-streaming.html
