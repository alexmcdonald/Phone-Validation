public class PhoneValidationIA {
    
    private static String baseEndpoint = 'https://REGION-PROJECT_ID.cloudfunctions.net/phoneParse';
    private static String apiKey = 'REPLACEWITHUNIQUEKEY';
    
    @InvocableMethod(label='Phone Validation IA')
    public static List<OutputData> execute(List<InputData> inputs) {
        List<OutputData> outputs = new List<OutputData>();
        
        for(InputData input : inputs) {
            OutputData output = new OutputData();
            String country = (!String.isBlank(input.country)) ? input.country : 'AU';
            if(!String.isBlank(input.phone)) {
                ParserResponse resp = parse(input.phone, country);
                if(resp.success) {
                    output.formattedPhone = resp.xnumber;
                    output.phoneIsValid = true;
                } else {
                    output.formattedPhone = input.phone;
                    output.phoneIsValid = false;
                    output.phoneMessage = resp.error;
                    System.debug('Phone Parsing Unsuccessful: '+resp.error);
                }
            }
            if(!String.isBlank(input.mobile)) {
                ParserResponse resp = parse(input.mobile, country);
                if(resp.success) {
                	if(resp.type == 'MOBILE') {
                    	output.formattedMobile = resp.xnumber;
                    	output.mobileIsValid = true;
                    } else {
                        output.formattedMobile = input.mobile;
                        output.mobileIsValid = false;
                        output.mobileMessage = 'Not a valid mobile number.';
                        System.debug('Not a mobile number');
                    }
                } else {
                    output.mobileIsValid = false;
                    output.mobileMessage = resp.error;
                    System.debug('Mobile Parsing Unsuccessful: '+resp.error);
                }                
            }
            if(!String.isBlank(input.fax)) {
                ParserResponse resp = parse(input.fax, country);
                if(resp.success) {
                    output.formattedFax = resp.xnumber;
                    output.faxIsValid = true;
                } else {
                    output.formattedFax = input.fax;
                    output.faxIsValid = false;
                    output.faxMessage = resp.error;
                    System.debug('Phone Parsing Unsuccessful: '+resp.error);
                }
            }
            outputs.add(output);
        }
        return outputs;
    }
    
    public class InputData {
        @InvocableVariable public String phone;
        @InvocableVariable public String mobile;
        @InvocableVariable public String fax;
        @InvocableVariable public String country;
    }
    
    public class OutputData {
        @InvocableVariable public String formattedPhone;
        @InvocableVariable public String formattedMobile;
        @InvocableVariable public String formattedFax;
        @InvocableVariable public Boolean phoneIsValid;
        @InvocableVariable public Boolean mobileIsValid;
        @InvocableVariable public Boolean faxIsValid;
        @InvocableVariable public String phoneMessage;
        @InvocableVariable public String mobileMessage;
        @InvocableVariable public String faxMessage;
    }
    
    public static ParserResponse parse(String phone, String country) {
        
        ParserResponse response = new ParserResponse();
        try {
            HttpRequest req = new HttpRequest();
            req.setEndpoint(baseEndpoint+'?key='+apiKey+'&phone='+EncodingUtil.UrlEncode(phone, 'UTF-8')+'&country='+country);
            req.setMethod('GET');
            req.setHeader('Content-Type','application/json');
            
            Http http = new Http();
	        HttpResponse res = http.send(req);
            
            String responseBody = res.getBody().replace('"number":','"xnumber":');
            response = (ParserResponse) JSON.deserialize(responseBody, ParserResponse.class);
            if(response.isValid) {
                response.success = true;
            } else {
                response.success = false;
                response.error = 'Invalid Number';
            }
        } catch(Exception e) {
            response.success = false;
            response.error = e.getMessage();
        }
        return response;
    }
    
    public class ParserResponse {
        public String xnumber;
        public String type;
        public Boolean isValid;
        public Boolean success;
        public String error;
    }

}