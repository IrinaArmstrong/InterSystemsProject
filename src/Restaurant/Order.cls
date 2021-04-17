/// Ordes - list of Meals
Class Restaurant.Order Extends %Persistent
{

Property State As %String(MAXLEN = 15);

Property ClientID As %Integer;
// Relationship Client As Restaurant.Client [ Cardinality = one, Inverse = Order ];

// Meals IDs, can repeat if there are multiple samples of single item
Property Meals As list Of %Integer;

// Total cost of oreder instance
Property Cost As %Float;

ClassMethod create(AddClientId As %Integer) As Restaurant.Order
{
    set order = ..%New()
    set order.ClientID = AddClientId
    set order.State = "Created"
    set order.Cost = 0.0
    set order.Meals = []
    set st =  order.%Save()
    return order
}

// Edit order's profile
Method addMealsToOrder(MealsToAdd As %Collection.ListOfDT, Cost As %Float) As %DynamicArray
{
    set result = {}
    For i=1:1:MealsToAdd.%Size() {
        set addResult = ..Meals.Insert(MealsToAdd.%Get(i))
        write addResult
    }
    set ..Cost = Cost
    set saveResult = ..%Save()
    
    if $$$ISOK(saveResult) set result = {"result": true}
    else  set result = {"result": false}
        set ErrorMessage = ##class(%SYSTEM.Status).GetErrorText(saveResult)
        set result.message = ErrorMessage
    
    return result.%ToJSON()
}

// Save a request object to table

/// <var>reqObj</var> - request object
ClassMethod add(reqObj) As %DynamicArray
{
  set result = {}
  set obj = ..%New()
  set obj.ClientID = reqObj.Get("clientid")
  set obj.Status = reqObj.Get("status")
  set obj.Meals = reqObj.Get("meals")
  set saveResult = obj.%Save()

  if $$$ISOK(saveResult) set result = {"result": true}
  else  set result = {"result": false}
  set ErrorMessage = ##class(%SYSTEM.Status).GetErrorText(saveResult)
  set result.message = ErrorMessage

  return result.%ToJSON()
}

/// Get all places from the table
ClassMethod getAll() As %DynamicArray
{
    set orders = []
    set data = ##class(%SQL.Statement).%ExecDirect(, "SELECT * FROM Restaurant.Order")
    while data.%Next() {
        set obj = {
            "id": (data.ID),
            "status": (data.Status),
            "clientid": (data.ClientID),
            "meals": (data.Meals)
        }

        do orders.%Push(obj)
    }
    return orders.%ToJSON()
}


/// Edit order's profile
ClassMethod changeCostOfOrder(OrderID As %Integer, CostToAdd As %Float) As %DynamicArray
{
    set Id = OrderID
    set order = ..%OpenId(Id)
    set result = {}

    if $IsObject(order) {
        set order.Cost = CostToAdd
        set saveResult = order.%Save()
    
        if $$$ISOK(saveResult) set result = {"result": true}
        else  set result = {"result": false}
        set ErrorMessage = ##class(%SYSTEM.Status).GetErrorText(saveResult)
        set result.message = ErrorMessage
    } else {
        set result = {"result": false}
        set result.message = "Invalid Order Object Selected"
    }
    return result.%ToJSON()
}

ClassMethod changeStatusOfOrder(OrderID As %Integer, NewStatus As %String) As %DynamicArray
{
    set Id = OrderID
    set order = ..%OpenId(Id)
    set result = {}

    if $IsObject(order) {
        set order.Status = NewStatus
        set saveResult = order.%Save()
    
        if $$$ISOK(saveResult) set result = {"result": true}
        else  set result = {"result": false}
        set ErrorMessage = ##class(%SYSTEM.Status).GetErrorText(saveResult)
        set result.message = ErrorMessage
    } else {
        set result = {"result": false}
        set result.message = "Invalid Order Object Selected"
    }
    return result.%ToJSON()
}


ClassMethod GetOrder(ID As %Integer) As Restaurant.Order
{
    set obj = ##class(Restaurant.Order).%OpenId(ID)
    Return obj
}

ClassMethod GetOrderStatus(ID As %Integer) As %String
{
    set obj = ##class(Restaurant.Order).%OpenId(ID)
    Return obj.Status
}

Storage Default
{
<Data name="OrderDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ID</Value>
</Value>
<Value name="3">
<Value>ClientID</Value>
</Value>
<Value name="4">
<Value>State</Value>
</Value>
<Value name="5">
<Value>Client</Value>
</Value>
<Value name="6">
<Value>Meals</Value>
</Value>
<Value name="7">
<Value>Cost</Value>
</Value>
</Data>
<DataLocation>^Restaurant.OrderD</DataLocation>
<DefaultData>OrderDefaultData</DefaultData>
<IdLocation>^Restaurant.OrderD</IdLocation>
<IndexLocation>^Restaurant.OrderI</IndexLocation>
<StreamLocation>^Restaurant.OrderS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
