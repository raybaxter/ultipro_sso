require 'rest-client'

def login_service_address
  "https://YOUR_HOST/services/LoginService"
end

def sso_user_service_address
  "https://YOUR_HOST/services/EmployeeSsoUser"
end

def user_name
  "USER_NAME"
end

def password
  "PASSWORD"
end

def email
  "EMAIL"
end

def user_api_key
  "API_KEY"
end

def customer_api_key
  "CUSTOMER_API_KEY"
end

# END CONFIGURATION SECTION

def response
  RestClient.post(login_service_address, login_xml, headers={"Content-Type" => "application/soap+xml"})
end

def token
  response.body.gsub(/.*loginservice\">/,'').gsub(/<\/Token.*/,"")
end

def login_xml
  <<-XML
  <s:Envelope xmlns:s="http://www.w3.org/2003/05/soap-envelope" xmlns:a="http://www.w3.org/2005/08/addressing">
    <s:Header>
      <a:Action s:mustUnderstand="1">http://www.ultipro.com/services/loginservice/ILoginService/Authenticate</a:Action>
      <h:ClientAccessKey xmlns:h="http://www.ultipro.com/services/loginservice">#{customer_api_key}</h:ClientAccessKey>
      <h:Password xmlns:h="http://www.ultipro.com/services/loginservice">#{password}</h:Password>
      <h:UserAccessKey xmlns:h="http://www.ultipro.com/services/loginservice">#{user_api_key}</h:UserAccessKey>
      <h:UserName xmlns:h="http://www.ultipro.com/services/loginservice">#{user_name}</h:UserName>
    </s:Header>
    <s:Body>
      <TokenRequest xmlns="http://www.ultipro.com/contracts" />
    </s:Body>
  </s:Envelope>
  XML
end

def create_sso_user_xml(client_user_name, employee_number)
  <<-XML
  <s:Envelope xmlns:a="http://www.w3.org/2005/08/addressing" xmlns:s="http://www.w3.org/2003/05/soap-envelope">
    <s:Header>
      <a:Action s:mustUnderstand="1">http://www.ultipro.com/services/employeessouser/IEmployeeSsoUser/CreateSsoUser</a:Action>
      <UltiProToken xmlns="http://www.ultimatesoftware.com/foundation/authentication/ultiprotoken">#{token}</UltiProToken>
      <ClientAccessKey xmlns="http://www.ultimatesoftware.com/foundation/authentication/clientaccesskey">#{customer_api_key}</ClientAccessKey>
      <a:MessageID>urn:uuid:7648d68d-38cf-473c-9ac3-0c44b27a83f1</a:MessageID>
      <a:ReplyTo>
        <a:Address>http://www.w3.org/2005/08/addressing/anonymous</a:Address>
      </a:ReplyTo>
    </s:Header>
    <s:Body>
      <CreateSsoUser xmlns="http://www.ultipro.com/services/employeessouser">
        <entities xmlns:d4p1="http://www.ultipro.com/contracts" xmlns:i="http://www.w3.org/2001/XMLSchema-instance">
          <d4p1:SsoUser>
            <d4p1:ClientUserName>#{client_user_name}</d4p1:ClientUserName>
            <d4p1:EmployeeIdentifier i:type="d4p1:EmployeeNumberIdentifier">
              <d4p1:EmployeeNumber>#{employee_number}</d4p1:EmployeeNumber>
            </d4p1:EmployeeIdentifier>
            <d4p1:RetryAttempts>0</d4p1:RetryAttempts>
            <d4p1:Status>1</d4p1:Status>
            <d4p1:UltiProUserName>#{client_user_name}</d4p1:UltiProUserName>
          </d4p1:SsoUser>
        </entities>
      </CreateSsoUser>
    </s:Body>
  </s:Envelope>
  XML
end

DATA.each_line do |line|
  line.chomp!
  employee_number, client_user_name = line.split(/,/)
  client_user_name = client_user_name.gsub(/\"/,"")
  r = RestClient.post(sso_user_service_address, create_sso_user_xml(client_user_name, employee_number), headers={"Content-Type" => "application/soap+xml"})
  success = r.body.gsub(/.*<b:Success>/,'').gsub(/<\/b:Success>.*/,'')
  puts "#{success}    #{employee_number}    #{client_user_name}"
end

__END__
1234,"bob@example.com"
2345,"alice@example.com"
3456,"jane@example.com"
