const { parsePhoneNumberFromString } = require('libphonenumber-js');
const countries = require('i18n-iso-countries');

// Google Cloud Function: phoneParse
exports.phoneParse = (req, res) => {
    // Your valid API key (store this securely in a real-world scenario)
    const validApiKey = 'REPLACEWITHUNIQUEKEY';

    // Get the API key from the request's query parameters or headers
    const apiKey = req.query.key || req.headers['x-api-key'];

    // Check if the API key matches the expected one
    if (apiKey !== validApiKey) {
        // Return a 401 Unauthorized response if the API key is invalid
        return res.status(401).send('Unauthorized: Invalid API key');
    }

    // Proceed with your main function logic (phone number parsing, etc.)
    const phoneNumber = req.query.phone || req.body.phone;
    let country = req.query.country || req.body.country;

    if (!phoneNumber) {
      return res.status(400).send({ Error: 'Phone number is required.' });
    }

    // If country is provided as a full name, convert it to ISO alpha-2 code
    if (country && country.length > 2) {
        console.log(`Attempting to match country: ${country}`);

        // Use i18n-iso-countries to get the 2-letter ISO code
        country = countries.getAlpha2Code(country, 'en');

        if (!country) {
            console.log('Country not found, returning error.');
            return res.status(400).send('Error: Invalid country name.');
        }
        console.log(`Converted country to ISO code: ${country}`);
    }

    let parsedNumber;
    if(phoneNumber.startsWith('+')) {
        parsedNumber = parsePhoneNumberFromString(phoneNumber);
    } else {
        parsedNumber = parsePhoneNumberFromString(phoneNumber, country);
    }

    if (!parsedNumber) {
      throw new Error('Invalid phone number.');
    }

    res.status(200).send({
      original: phoneNumber,
      number: parsedNumber.number,
      formatted: parsedNumber.formatInternational(),
      country: parsedNumber.country,
      type: parsedNumber.getType(),
      isValid: parsedNumber.isValid(),
      isPossible: parsedNumber.isPossible()
    });

};