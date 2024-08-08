# README

The application allows you to upload xlsx files, extract information about companies from them and create [OKDESK](https://okdesk.ru) companies based on this information

## Installing
Before starting, you should make sure that the necessary components are installed on your system:
* [Ruby](https://www.ruby-lang.org/en/documentation/installation/)
* [SQLite3](https://www.sqlite.org/download.html)
* [Ruby on Rails](https://guides.rubyonrails.org/getting_started.html)

To run the application locally:
* Clone this repository to a local folder
* Open terminal and go to the "okdesktest" folder ``` cd <local_folder_path>/okdesktest ```
* Install gem packages with ``` bundle i ```
* Run the application with ``` rails s ```
* Open browser on http://localhost:3000
* Register and enter the data to access the [Okdesk API](https://apidocs.okdesk.ru/apidoc) to use the file download service
* Go to the "Uploads" tab and upload your xlsx file with companies or use the test file shown below
* [Test companies.xlsx](https://github.com/pavelvladimirmorozov/okdesktest/blob/main/Test%20companies.xlsx) - file with the required format and a test set of companies

**Note:** This app is made to pass the test task and works only with the test API [https://<okdesk_account>.**test**okdesk.ru/api/v1](https://testokdesk.ru/)
