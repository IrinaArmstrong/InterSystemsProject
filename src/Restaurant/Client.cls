/// Client - person
Class Restaurant.Client Extends %Persistent
{

/// Clients order
Property Order As Restaurant.Order;
// Relationship Order As Restaurant.Order [ Cardinality = many, Inverse = Client ];


Property Login As %String [ Required ];

Property Password As %String [ Required ];

Property Name As %String [ Required ];

Property Phone As %String;

Property Email As %String;

Property DOB As %Date;

Property Age As %Integer [ Calculated, SqlComputeCode = { if ({DOB}="") { 
                                                        set {*} = ""} else {
                                                        set {*} = ($h-{DOB})\365.4
                                                    }}, SqlComputed ];

ClassMethod create(Login As %String, Password As %String, Name As %String, Phone As %String, Email As %String, DOB As %Date) As Restaurant.Client
{
    set client = ..%New()
    set client.Login = Login
    set client.Password = Password
    set client.Name = Name
    set client.Phone = Phone
    set client.Email = Email
    set client.DOB = DOB
    // set client.Order = ##class(Restaurant.Order).%create(client.ID)

    set st =  ..DOBIsValid(client.%Save())
    return client.%Id() 
}

/// Login user
ClassMethod login(Login As %String, Password As %String) As %Status
{
    set result = {"assepted": false}
    set data = ##class(%SQL.Statement).%ExecDirect(, "SELECT * FROM Restaurant.Client")
    while data.%Next() {
        set obj = {
            "id": (data.ID),
            "login": (data.Login),
            "password": (data.Password)
        }
        if (obj.login = Login) && (obj.password = Password) {
            set result = {"assepted": true}
            set result.client = obj.id
        }
    }
    return result.%ToJSON()
}

/// Edit order's profile
ClassMethod createClientsOrder(ClientID As %String, MealsToAdd As %Collection.ArrayOfObj, TotalCost As %Float) As %DynamicArray
{
    set client = ..%OpenId(ClientID)
    set result = {}

    #; if $IsObject(client) {} else {
    #;     set result = {"result": false}
    #;     set result.message = "Invalid Order Object Selected"
    #; }
        // set client.Order = ##class(Restaurant.Order).%create(ClientID)
    set client.Order = ##class(Restaurant.Order).%New()

    set addStatus = client.Order.addMealsToOrder(MealsToAdd, TotalCost)   
    set saveResult = client.%Save()
    
    if $$$ISOK(saveResult) set result = {"result": true}
    else  set result = {"result": false}
    set ErrorMessage = ##class(%SYSTEM.Status).GetErrorText(saveResult)
    set result.message = ErrorMessage
    
    return result.%ToJSON()
}

ClassMethod GetClient(ID As %Integer) As Restaurant.Client
{
    set obj = ##class(Restaurant.Client).%OpenId(ID)
    Return obj
}

/// Save a request object to table
ClassMethod add(reqObj) As %DynamicArray
{
  set result = {}
  set obj = ..%New()
  set obj.Login = reqObj.Get("login")
  set obj.Password = reqObj.Get("password")
  set obj.Name = reqObj.Get("name")
  set obj.Phone = reqObj.Get("phone")
  set obj.Email = reqObj.Get("email")
  set obj.DOB = ..DOBIsValid(reqObj.Get("dob")) 
  set saveResult = obj.%Save()

  if $$$ISOK(saveResult) set result = {"result": true}
  else  set result = {"result": false}
  set ErrorMessage = ##class(%SYSTEM.Status).GetErrorText(saveResult)
  set result.message = ErrorMessage

  return result.%ToJSON()
}

/// Get all clients from the table
ClassMethod getAll() As %DynamicArray
{
    set clients = []
    set data = ##class(%SQL.Statement).%ExecDirect(, "SELECT * FROM Restaurant.Client")
    while data.%Next() {
        set obj = {
            "id": (data.ID),
            "login": (data.Login),
            "password": (data.Password),
            "name": (data.Name),
            "phone": (data.Phone),
            "email": (data.Email),
            "dob": (data.DOB)
        }
        do clients.%Push(obj)
    }
    return clients.%ToJSON()
}

/// Delete client from table by id
/// <var>Id</var> - car id in the table
ClassMethod delete(Id As %String = "") As %DynamicArray
{
    set deleteResult = ..%DeleteId(Id)
    set result = {}
    if $$$ISOK(deleteResult) set result = {"result": true}
    else  set result = {"result": false}
    set ErrorMessage = ##class(%SYSTEM.Status).GetErrorText(deleteResult)
    set result.message = ErrorMessage
    return result.%ToJSON()
}

Storage Default
{
<Data name="ClientDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ID</Value>
</Value>
<Value name="3">
<Value>RegistrationDate</Value>
</Value>
<Value name="4">
<Value>OrderID</Value>
</Value>
<Value name="5">
<Value>ProfileCard</Value>
</Value>
<Value name="6">
<Value>Login</Value>
</Value>
<Value name="7">
<Value>Password</Value>
</Value>
<Value name="8">
<Value>Name</Value>
</Value>
<Value name="9">
<Value>Phone</Value>
</Value>
<Value name="10">
<Value>Email</Value>
</Value>
<Value name="11">
<Value>DOB</Value>
</Value>
</Data>
<DataLocation>^Restaurant.ClientD</DataLocation>
<DefaultData>ClientDefaultData</DefaultData>
<IdLocation>^Restaurant.ClientD</IdLocation>
<IndexLocation>^Restaurant.ClientI</IndexLocation>
<StreamLocation>^Restaurant.ClientS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
