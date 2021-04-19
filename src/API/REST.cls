/// Description
Class Restaurant.Api.Rest Extends %CSP.REST
{

/// By default convert the input stream to Unicode
Parameter CONVERTINPUTSTREAM = 1;

Parameter HandleCorsRequest = 1;

/// Default the Content-Type for this application.
Parameter CONTENTTYPE = "application/json";

/// The default response charset is utf-8
Parameter CHARSET = "utf-8";

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
  <Route Url="/test" Method="get" Call="TestPage" />

  <Route Url="/client/register" Method="post" Call="ClientRegister" />
  <Route Url="/client/login" Method="get" Call="ClientLogin" />
  <Route Url="/client/add" Method="get" Call="ClientAdd" />
  <Route Url="/client/delete" Method="delete" Call="ClientDelete" />
  <Route Url="/client/createOrder" Method="post" Call="ClientsCreateOrder" />
  <Route Url="/client/getAll" Method="get" Call="ClientsGetAll" />

  <Route Url="/order/create" Method="post" Call="getAll" />
  <Route Url="/order/getAll" Method="get" Call="getAll" />
  <Route Url="/order/getStatus" Method="get" Call="OrderGetStatus" />
  <Route Url="/order/add" Method="post" Call="OrderAdd" />
  <Route Url="/order/get" Method="get" Call="OrderGet" />
  <Route Url="/order/delete" Method="get" Call="OrderDelete" />
  <Route Url="/order/getAll" Method="get" Call="OrdersGetAll" />

  <Route Url="/meal/getAll" Method="get" Call="MealsGetAll" />


</Routes>
}

ClassMethod TestPage() As %Status
{
  Set currentDate = $ZDate($Now(), 3)
  Set obj = {"msg":"It works", "today": (currentDate)}
  Write obj.%ToJSON()
  Return $$$OK
}

ClassMethod Test() As %Status
{
  write "hello this is test"
  return $$$OK
}

/// Clients methods
ClassMethod ClientsGetAll() As %Status
{
  Try {
    write ##class(Restaurant.Client).getAll()
    return $$$OK
  } Catch {
    set result = {"result": false}
    set result.message = $ZCVT(exception.Name_" "_exception.Location, "O", "HTML")
    write result.%ToJSON()
    Return $$$ERROR(500)
  }
}

ClassMethod ClientRegister() As %Status
{
  set login = %request.Get("login")
  set password = %request.Get("password")
  set name = %request.Get("name")
  set phone = %request.Get("phone")
  set email = %request.Get("email")
  set dob = %request.Get("dob")
  set result = ##class(Restaurant.Client).create(login, password, name, phone, email, dob)
  write result
  return $$$OK
}

ClassMethod ClientLogin() As %Status
{
  set login = %request.Get("login")
  set password = %request.Get("password")
  set result = ##class(Restaurant.Client).login(%request.Get("login"), %request.Get("password"))
  write result
  return $$$OK
}

ClassMethod ClientsCreateOrder() As %Status
{
  Try {
    set id = %request.Get("id")
    set meals = %request.Get("meals")
    set cost = %request.Get("cost")
    write ##class(Restaurant.Client).createClientsOrder(id, meals, cost)
    return $$$OK
  } Catch {
    set result = {"result": false}
    //set result.message = $ZCVT(exception.Name_" "_exception.Location, "O", "HTML")
    write result.%ToJSON()
    Return $$$ERROR(500)
  }
}

ClassMethod ClientAdd() As %Status
{
  set result = ##class(Restaurant.Client).add(%request)
  write result
  return $$$OK
}

ClassMethod ClientGet() As %Status
{
  set id = %request.Get("id")
  set result = ##class(Restaurant.Client).get(id)
  write result
  return $$$OK
}

ClassMethod ClientDelete() As %Status
{
  set id = %request.Get("id")
  set deleteResult = ##class(Restaurant.Client).delete(id)
  write deleteResult
  return $$$OK
}

/// Orders methods
/// 
 ClassMethod OrderCreate() As %Status
{
  set clientid = %request.Get("clientid")
  set meals = %request.Get("meals")
  set cost = %request.Get("cost")
  set result = ##class(Restaurant.Order).create(clientid, meals, cost)
  write result
  return $$$OK
}

ClassMethod OrderGetStatus() As %Status
{
  set id = %request.Get("id")
  set result = ##class(Restaurant.Order).GetOrderStatus(id)
  write result.Status
  return $$$OK
}

ClassMethod OrderAdd() As %Status
{
  set result = ##class(Restaurant.Order).add(%request)
  write result
  return $$$OK
}

ClassMethod OrderGet() As %Status
{
  set id = %request.Get("id")
  set result = ##class(Restaurant.Order).get(id)
  write result
  return $$$OK
}

ClassMethod OrderDelete() As %Status
{
  set id = %request.Get("id")
  set deleteResult = ##class(Restaurant.Order).delete(id)
  write deleteResult
  return $$$OK
}

ClassMethod OrdersGetAll() As %Status
{
  Try {
    write ##class(Restaurant.Order).getAll()
    return $$$OK
  } Catch {
    set result = {"result": false}
    set result.message = $ZCVT(exception.Name_" "_exception.Location, "O", "HTML")
    write result.%ToJSON()
    Return $$$ERROR(500)
  }
}

/// Meals methods
ClassMethod MealsGetAll() As %Status
{
  Try {
    write ##class(Restaurant.Meal).getAll()
    return $$$OK
  } Catch {
    set result = {"result": false}
    set result.message = $ZCVT(exception.Name_" "_exception.Location, "O", "HTML")
    write result.%ToJSON()
    Return $$$ERROR(500)
  }
}

}
