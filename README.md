# Phone-Validation

Phone number validation leveraging libphonenumber-js and i18n-iso-countries.

To run as a Google Cloud Function:

1) Install Google Cloud CLI (https://cloud.google.com/sdk/docs/install)

2) Initialize the CLI, log in/select your Google Cloud project, and enable Cloud Functions API:
```
gcloud init
gcloud services enable cloudfunctions.googleapis.com
```

3) Install Node.js

4) Create a directory for the Cloud Function Project, and `cd` into it

5) Initialize a new Node.js project, and install the dependencies
```
npm init -y
npm install libphonenumber-js
npm install i18n-iso-countries
```

6) Copy the index.js and package.json files from this repository

7) Update the API key to something random

8) Deploy the function
```
gcloud functions deploy phoneParse \
--runtime nodejs18 \
--trigger-http \
--allow-unauthenticated
```

9) Test you can now access the service at `https://REGION-PROJECT_ID.cloudfunctions.net/phoneParse?key=KEY&phone=+0412345678&country=AU`

10) Deploy the PhoneValidationIA Apex class to your Salesforce org

11) Add a remote site setting for your Google Cloud project URL `https://REGION-PROJECT_ID.cloudfunctions.net`

12) You can now call the service as a Flow Action, passing a phone, mobile and/or fax number in.  The action will validate each inputted number and if successful will return the internal formatted number.  For Mobile numbers, the service will validate that it is a valid mobile number.
