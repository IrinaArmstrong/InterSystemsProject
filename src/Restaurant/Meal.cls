/// Meal
Class Restaurant.Meal Extends %Persistent
{

Property Name As %String [ Required ];

Property Description As %String;

Property Price As %Float;

Property Rating As %Float;

ClassMethod create(Name As %String, Description As %String, Price As %Float, Rating As %Float) As Restaurant.Meal
{
    set meal = ..%New()
    set meal.Name = Name
    set meal.Description = Description
    set meal.Price = Price
    set meal.Rating = Rating
    set st =  meal.%Save()
    return meal
}

/// Save a request object to table
/// <var>reqObj</var> - request object
ClassMethod add(reqObj) As %DynamicArray
{
  set result = {}
  set obj = ..%New()
  set obj.Name = reqObj.Get("name")
  set obj.Description = reqObj.Get("description")
  set obj.Price = reqObj.Get("price")
  set obj.Rating = reqObj.Get("rating")
  set saveResult = obj.%Save()

  if $$$ISOK(saveResult) set result = {"result": true}
  else  set result = {"result": false}
  set ErrorMessage = ##class(%SYSTEM.Status).GetErrorText(saveResult)
  set result.message = ErrorMessage

  return result.%ToJSON()
}

/// Delete meal from table by id
/// <var>Id</var> - meal id in the table
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

/// Get meals names list for select editor
ClassMethod getNameSelectList() As %DynamicArray
{
    set list = []
    set data = ##class(%SQL.Statement).%ExecDirect(, "SELECT * FROM Restaurant.Meal")
    while data.%Next() {
        set obj = {
            "id": (data.ID),
            "value": (data.Name),
            "description": (data.Description),
            "price": (data.Price)
        }
        do list.%Push(obj)
    }
    return list.%ToJSON()
}

/// Get all meals array (json) from table
ClassMethod getAll() As %DynamicArray
{
    set meals = []
    set data = ##class(%SQL.Statement).%ExecDirect(, "SELECT * FROM Restaurant.Meal")
    while data.%Next() {
        set obj = {
            "id": (data.ID),
            "value": (data.Name),
            "description": (data.Description),
            "price": (data.Price),
            "rating": (data.Rating)
        }
        do meals.%Push(obj)
    }
    return meals.%ToJSON()
}

ClassMethod PrintAllMeals() As %Status
{
    set data = ##class(%SQL.Statement).%ExecDirect(, "SELECT * FROM Restaurant.Meal")
    while data.%Next() {
        write $$$NL
        write data.Name
        write $$$NL
        write data.Description
        write $$$NL
        write data.Price
        write $$$NL
    }
}

ClassMethod GetMeal(ID As %Integer) As Restaurant.Meal
{
    set obj = ##class(Restaurant.Meal).%OpenId(ID)
    Return obj
}

Storage Default
{
<Data name="MealDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MealID</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>Description</Value>
</Value>
<Value name="5">
<Value>Price</Value>
</Value>
<Value name="6">
<Value>Rating</Value>
</Value>
<Value name="7">
<Value>ID</Value>
</Value>
<Value name="8">
<Value>Order</Value>
</Value>
</Data>
<DataLocation>^Restaurant.MealD</DataLocation>
<DefaultData>MealDefaultData</DefaultData>
<IdLocation>^Restaurant.MealD</IdLocation>
<IndexLocation>^Restaurant.MealI</IndexLocation>
<StreamLocation>^Restaurant.MealS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
