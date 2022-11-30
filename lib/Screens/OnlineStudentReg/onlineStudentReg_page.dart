/*
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:http/http.dart' as http;
import 'package:tcs_app/Utils/app_constants.dart';
import 'package:tcs_app/model/osrCampus.dart';
import 'package:tcs_app/model/osrCities.dart';
import 'package:tcs_app/model/osrClass.dart';
import 'package:tcs_app/model/osrCountries.dart';
import 'package:tcs_app/model/osrRegResponse.dart';
import 'package:tcs_app/model/osrRegistration.dart';
import 'package:tcs_app/model/osrSession.dart';

class OnlineRegistrationForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new OnlineRegistrationFormState();
  }
}

class OnlineRegistrationFormState extends State<OnlineRegistrationForm> {
  String _nationality, _dateOfBirth, gender;
  int _minYear = 1980,
      _maxYear = DateTime.now().year,
      _selectedSession,
      _selectedCity,
      _selectedCampus,
      _selectedClass;
  FocusNode surnameNode = new FocusNode();
  FocusNode dayNode = new FocusNode();
  FocusNode monthNode = new FocusNode();
  FocusNode yearNode = new FocusNode();
  FocusNode psLocationNode = new FocusNode();
  FocusNode studiedFromClassNode = new FocusNode();
  FocusNode studiedToClassNode = new FocusNode();
  FocusNode rxnForLeavingNode = new FocusNode();
  FocusNode fatherCNICNode = new FocusNode();
  FocusNode fatherOccupationNode = new FocusNode();
  FocusNode fatherMobileNoNode = new FocusNode();
  FocusNode fatherEmailNode = new FocusNode();

  DateFormat formatDate = new DateFormat('dd-MMM-yyyy');
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  MaskedTextController dayController = new MaskedTextController(mask: '00');
  MaskedTextController monthController = new MaskedTextController(mask: '00');
  MaskedTextController yearController = new MaskedTextController(mask: '0000');
  TextEditingController nameController = TextEditingController();
  TextEditingController surNameController = TextEditingController();
  TextEditingController previousSchoolController = TextEditingController();
  TextEditingController pSLocationController = TextEditingController();
  TextEditingController studiedFromClassController = TextEditingController();
  TextEditingController studiedToClassController = TextEditingController();
  TextEditingController leavingRxnController = TextEditingController();
  TextEditingController fatherNameController = TextEditingController();
  MaskedTextController fatherCNICController =
      MaskedTextController(mask: '00000-0000000-0');
  TextEditingController fatherOccupationController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController emailAddressController = TextEditingController();
  RegExp nameRegExp = RegExp(r'^[a-zA-Z_ ]*$');
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  List<GlobalKey<FormState>> _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  var osrListSessions = new List<OSRSessionModel>();
  var osrListCities = new List<OSRCitiesModel>();
  var osrListCampus = new List<OSRCampusModel>();
  var osrListClass = new List<OSRClassModel>();
  var osrListCountries = new List<OSRCountriesModel>();

  String _selectedCityName,
      _selectedSessionName,
      _selectedCampusName,
      _selectedClassName;

  int _radioValueGender = -1, _radioValuePreviousSchool = -1, stepCounter = 0;
  bool _autoValidate = false,
      _autoValidate1 = false,
      _autoValidate2 = false,
      _autoValidate3 = false,
      isLoading = false,
      connected,
      previousSchool,
      isSuccessful = false;

  StepState _getState(int i) {
    if (stepCounter > i)
      return StepState.complete;
    else if (stepCounter == i)
      return StepState.editing;
    else if (stepCounter < i)
      return StepState.disabled;
    else
      return StepState.indexed;
  }

  Widget datetime() {
    return CupertinoDatePicker(
      initialDateTime: DateTime.now(),
      onDateTimeChanged: (DateTime newDate) {
        dayController.text = newDate.day.toString();
        monthController.text = newDate.month.toString();
        yearController.text = newDate.year.toString();
        DateTime date = DateTime.parse(newDate.year.toString() +
            '-' +
            newDate.month.toString().padLeft(2, '0') +
            '-' +
            newDate.day.toString().padLeft(2, '0'));
        _dateOfBirth = formatDate.format(date);
      },
      minimumYear: 1980,
      maximumYear: _maxYear,
      mode: CupertinoDatePickerMode.date,
    );
  }

  Future _loadDropdownSessions() async {
    try {
      http.Response response = await http.post('${AppConstants.apiBaseURL}/OSR/AllSessions',
          headers: {
            'content-type': 'application/json'
          }).timeout(Duration(minutes: 2));
      Iterable list = json.decode(response.body);
      setState(() {
        osrListSessions =
            list.map((model) => OSRSessionModel.fromJson(model)).toList();
      });
    } catch (exception) {
      final snackBar = new SnackBar(
        content: new Text(exception),
        duration: new Duration(milliseconds: 1000),
      );
      scaffoldKey.currentState.showSnackBar(snackBar);
    }
  }

  Future _loadDropdownCities() async {
    setState(() {
      _selectedCampus = null;
      _selectedClass = null;
      osrListClass = new List<OSRClassModel>();
      osrListCampus = List<OSRCampusModel>();
    });
    try {
      http.Response response = await http
          .post('${AppConstants.apiBaseURL}/OSR/AllCities', headers: {
        'content-type': 'application/json'
      }).timeout(Duration(minutes: 2));
      Iterable list = json.decode(response.body);
      setState(() {
        osrListCities =
            list.map((model) => OSRCitiesModel.fromJson(model)).toList();
      });
    } catch (exception) {
      final snackBar = new SnackBar(
        content: new Text(exception),
        duration: new Duration(milliseconds: 1000),
      );
      scaffoldKey.currentState.showSnackBar(snackBar);
    }
  }

  Future _loadDropdownCountries() async {
    setState(() {
      isLoading = true;
    });
    try {
      var connectivityResult = await (new Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        http.Response response = await http.post('${AppConstants.apiBaseURL}/OSR/Countries',
            headers: {
              'content-type': 'application/json'
            }).timeout(Duration(minutes: 2));
        Iterable list = json.decode(response.body);
        setState(() {
          osrListCountries =
              list.map((model) => OSRCountriesModel.fromJson(model)).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        final snackBar = new SnackBar(
          content: new Text('Connect your internet'),
          duration: new Duration(milliseconds: 1000),
        );
        scaffoldKey.currentState.showSnackBar(snackBar);
      }
    } on TimeoutException catch (_) {
      setState(() {
        isLoading = false;
      });
      final snackBar = new SnackBar(
        content: new Text('Connection Timeout'),
        duration: new Duration(milliseconds: 1000),
      );
      scaffoldKey.currentState.showSnackBar(snackBar);
    } catch (exception) {
      setState(() {
        isLoading = false;
      });
      final snackBar = new SnackBar(
        content: new Text(exception),
        duration: new Duration(milliseconds: 1000),
      );
      scaffoldKey.currentState.showSnackBar(snackBar);
    }
  }

  Future _loadDropdownCampus(int id) async {
    setState(() {
      _selectedCampus = null;
      _selectedClass = null;
      osrListClass = new List<OSRClassModel>();
      osrListCampus = List<OSRCampusModel>();
    });
    try {
      var connectivityResult = await (new Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        Map body = {
          'Id': id,
        };
        http.Response response = await http.post('${AppConstants.apiBaseURL}/OSR/CampusByCity',
            body: utf8.encode(json.encode(body)),
            headers: {
              'content-type': 'application/json'
            }).timeout(Duration(minutes: 2));
        Iterable list = json.decode(response.body);
        setState(() {
          osrListCampus =
              list.map((model) => OSRCampusModel.fromJson(model)).toList();
        });
      } else {
        final snackBar = new SnackBar(
          content: new Text('Connect your internet'),
          duration: new Duration(milliseconds: 1000),
        );
        scaffoldKey.currentState.showSnackBar(snackBar);
      }
    } catch (exception) {
      final snackBar = new SnackBar(
        content: new Text(exception),
        duration: new Duration(milliseconds: 1000),
      );
      scaffoldKey.currentState.showSnackBar(snackBar);
    }
  }

  Future _loadDropdownClass(int id) async {
    setState(() {
      _selectedClass = null;
      osrListClass = new List<OSRClassModel>();
    });
    try {
      var connectivityResult = await (new Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        Map body = {
          'Id': id,
        };
        http.Response response = await http.post('${AppConstants.apiBaseURL}/OSR/ClassByCampus',
            body: utf8.encode(json.encode(body)),
            headers: {
              'content-type': 'application/json'
            }).timeout(Duration(minutes: 2));
        Iterable list = json.decode(response.body);
        setState(() {
          osrListClass =
              list.map((model) => OSRClassModel.fromJson(model)).toList();
        });
      } else {
        final snackBar = new SnackBar(
          content: new Text('Connect your internet'),
          duration: new Duration(milliseconds: 1000),
        );
        scaffoldKey.currentState.showSnackBar(snackBar);
      }
    } catch (exception) {
      final snackBar = new SnackBar(
        content: new Text(exception),
        duration: new Duration(milliseconds: 1000),
      );
      scaffoldKey.currentState.showSnackBar(snackBar);
    }
  }

  _checkConnectivity() async {
    var connectivityResult = await (new Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      setState(() {
        connected = true;
      });
    } else {
      setState(() {
        connected = false;
      });
    }
  }

  @override
  void initState() {
    _loadDropdownSessions();
    _loadDropdownCities();
    _loadDropdownCountries();
    _checkConnectivity();
    super.initState();
  }

  void _handleGenderRadioValueChange(int value) {
    setState(() {
      _radioValueGender = value;

      switch (_radioValueGender) {
        case 0:
          gender = 'Male';
          break;
        case 1:
          gender = 'False';
          break;
      }
    });
  }

  void _handlePreviousEduRadioValueChange(int value) {
    setState(() {
      _radioValuePreviousSchool = value;
      switch (_radioValuePreviousSchool) {
        case 0:
          previousSchool = true;
          break;
        case 1:
          previousSchool = false;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Step> steps = [
      //Step 1
      Step(
        title: Text(
          'Student',
          style: TextStyle(fontSize: 20.0),
        ),
        content: Form(
            key: _formKeys[0],
            autovalidate: _autoValidate,
            child: new Container(
              child: Column(
                children: <Widget>[
                  new Padding(padding: EdgeInsets.all(3)),
                  new TextFormField(
                    onFieldSubmitted: (String value) {
                      FocusScope.of(context).requestFocus(surnameNode);
                    },
                    controller: nameController,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        labelText: 'First Name',
                        hintText: 'Name of student',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter Your First Name';
                      } else if (!nameRegExp.hasMatch(value)) {
                        return 'Enter Your Valid Name';
                      }
                      return null;
                    },
                    onSaved: (val) {
                      nameController.text = val;
                    },
                  ),
                  new Padding(padding: EdgeInsets.all(3)),
                  new TextFormField(
                    focusNode: surnameNode,
                    controller: surNameController,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                    keyboardType: TextInputType.text,
                    onFieldSubmitted: (String value) {
                      FocusScope.of(context).requestFocus(dayNode);
                    },
                    onSaved: (String val) {
                      surNameController.text = val;
                    },
                    decoration: InputDecoration(
                        labelText: 'Surname',
                        hintText: 'Surname of student',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter Your Surname';
                      } else if (!nameRegExp.hasMatch(value)) {
                        return 'Enter Your Valid Surname';
                      }
                      return null;
                    },
                  ),
                  new Padding(padding: EdgeInsets.all(10)),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      new Text(
                        'Gender',
                        style: new TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                  new Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        new Radio(
                          value: 0,
                          groupValue: _radioValueGender,
                          onChanged: _handleGenderRadioValueChange,
                        ),
                        new Text(
                          'Male',
                          style: new TextStyle(fontSize: 16.0),
                        ),
                        new Padding(padding: EdgeInsets.only(right: 10)),
                        new Radio(
                          value: 1,
                          groupValue: _radioValueGender,
                          onChanged: _handleGenderRadioValueChange,
                        ),
                        new Text(
                          'Female',
                          style: new TextStyle(fontSize: 16.0),
                        ),
                      ]),
                  new Padding(padding: EdgeInsets.only(top: 5)),
                  new Container(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: new TextFormField(
                            focusNode: dayNode,
                            controller: dayController,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.phone,
                            onFieldSubmitted: (String value) {
                              FocusScope.of(context).requestFocus(monthNode);
                            },
                            onSaved: (String val) {
                              dayController.text = val;
                            },
                            decoration: InputDecoration(
                                labelText: 'Date',
                                hintText: 'DD',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0))),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Day';
                              } else if (!(int.parse(value).compareTo(1) >= 0 &&
                                  int.parse(value).compareTo(31) <= 0)) {
                                return 'Invalid';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(
                          width: 20.0,
                          child: new Text(
                            '-',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 14.0),
                          ),
                        ),
                        Expanded(
                          child: new TextFormField(
                            focusNode: monthNode,
                            controller: monthController,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.phone,
                            onFieldSubmitted: (String value) {
                              FocusScope.of(context).requestFocus(yearNode);
                            },
                            onSaved: (String val) {
                              monthController.text = val;
                            },
                            decoration: InputDecoration(
                                labelText: 'Month',
                                hintText: 'MM',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0))),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Month';
                              } else if (!(int.parse(value).compareTo(1) >= 0 &&
                                  int.parse(value).compareTo(12) <= 0)) {
                                return 'Invalid';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(
                          width: 20.0,
                          child: new Text(
                            '-',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 14.0),
                          ),
                        ),
                        Expanded(
                          child: new TextFormField(
                            focusNode: yearNode,
                            controller: yearController,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.phone,
                            onSaved: (String val) {
                              yearController.text = val;
                            },
                            decoration: InputDecoration(
                              labelText: 'Year',
                              hintText: 'YYYY',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Year';
                              } else if (!(int.parse(value)
                                          .compareTo(_minYear) >=
                                      0 &&
                                  int.parse(value).compareTo(_maxYear) <= 0)) {
                                return 'Invalid';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(
                          width: 30.0,
                          child: GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext builder) {
                                    return Container(
                                      height: MediaQuery.of(context)
                                              .copyWith()
                                              .size
                                              .height /
                                          3,
                                      child: new Column(
                                        children: <Widget>[
                                          new Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: <Widget>[
                                              FlatButton(
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop(datetime());
                                                  },
                                                  child: new Text(
                                                    'Done',
                                                    style: TextStyle(
                                                        fontSize: 18.0,
                                                        color: Colors.blue),
                                                  ))
                                            ],
                                          ),
                                          Expanded(
                                            child: datetime(),
                                          )
                                        ],
                                      ),
                                    );
                                  });
                            },
                            child: Icon(Icons.today),
                          ),
                        ),
                      ],
                    ),
                  ),
                  new Padding(padding: EdgeInsets.only(top: 10)),
                  FormField<String>(
                    builder: (
                      FormFieldState<String> state,
                    ) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new InputDecorator(
                            decoration: InputDecoration(
                                labelText: 'Nationality',
                                contentPadding: EdgeInsets.only(
                                    left: 10.0, top: 5.0, bottom: 5.0),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0)),
                                errorText:
                                    state.hasError ? state.errorText : null),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                isExpanded: true,
                                hint: new Text('Select Nationality'),
                                value: _nationality,
                                onChanged: (String newValue) {
                                  setState(() {
                                    _nationality = newValue;
                                  });
                                  state.didChange(newValue);
                                },
                                items: osrListCountries.map((value) {
                                  return new DropdownMenuItem<String>(
                                    value: value.name,
                                    child: new Text(value.name),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    validator: (val) {
                      if (_nationality == null) {
                        return 'This Field is Required';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _nationality = value;
                    },
                  ),
                  new Padding(padding: EdgeInsets.only(top: 5.0)),
                ],
              ),
            )),
        state: _getState(0),
        isActive: stepCounter >= 0,
      ),
      //Step 2
      Step(
        title: Text('Admission', style: TextStyle(fontSize: 20.0)),
        content: new Form(
          key: _formKeys[1],
          autovalidate: _autoValidate1,
          child: new Column(
            children: <Widget>[
              new Padding(padding: EdgeInsets.all(3)),
              new Container(
                  margin: EdgeInsets.only(left: 2, top: 15),
                  child: Column(
                    children: <Widget>[
                      new Row(
                        children: <Widget>[
                          Expanded(
                            child: new Text(
                              'When is admission required?',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  )),
              new Padding(padding: EdgeInsets.all(3)),
              FormField<int>(
                builder: (
                  FormFieldState<int> state,
                ) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new InputDecorator(
                        decoration: InputDecoration(
                            labelText: 'Session',
                            contentPadding: EdgeInsets.only(
                                left: 10.0, top: 5.0, bottom: 5.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                            errorText: state.hasError ? state.errorText : null),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                            hint: new Text('Select Session'),
                            value: _selectedSession,
                            onChanged: (int newValue) {
                              setState(() {
                                _selectedSession = newValue;
                              });
                              state.didChange(newValue);
                              _selectedSessionName = osrListSessions
                                  .where((i) => i.id == _selectedSession)
                                  .map((f) => f.name)
                                  .toString();
                            },
                            items: osrListSessions.map((value) {
                              return new DropdownMenuItem<int>(
                                value: value.id,
                                child: new Text(value.name),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  );
                },
                validator: (value) {
                  if (value == null) {
                    return 'This Field is Required';
                  }
                  return null;
                },
                onSaved: (value) {
                  _selectedSession = value;
                },
              ),
              new Padding(padding: EdgeInsets.only(top: 10)),
              new Container(
                  margin: EdgeInsets.only(left: 2),
                  child: Column(
                    children: <Widget>[
                      new Row(
                        children: <Widget>[
                          Expanded(
                            child: new Text(
                              'Select City',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  )),
              new Padding(padding: EdgeInsets.all(3)),
              FormField<int>(
                builder: (
                  FormFieldState<int> state,
                ) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new InputDecorator(
                        decoration: InputDecoration(
                            labelText: 'City',
                            contentPadding: EdgeInsets.only(
                                left: 10.0, top: 5.0, bottom: 5.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                            errorText: state.hasError ? state.errorText : null),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                            hint: new Text('Select City'),
                            value: _selectedCity,
                            onChanged: (int newValue) {
                              setState(() {
                                _selectedCity = newValue;
                                _selectedCampus = null;
                                _selectedClass = null;
                              });
                              state.didChange(newValue);
                              _loadDropdownCampus(_selectedCity);
                              _selectedCityName = osrListCities
                                  .where((i) => i.id == _selectedCity)
                                  .map((f) => f.name)
                                  .toString();
                            },
                            items: osrListCities.map((value) {
                              return new DropdownMenuItem<int>(
                                value: value.id,
                                child: new Text(value.name),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  );
                },
                validator: (value) {
                  if (value == null) {
                    return 'This Field is Required';
                  }
                  return null;
                },
                onSaved: (value) {
                  _selectedCity = value;
                },
              ),
              new Padding(padding: EdgeInsets.only(top: 10)),
              new Container(
                  margin: EdgeInsets.only(left: 2),
                  child: Column(
                    children: <Widget>[
                      new Row(
                        children: <Widget>[
                          Expanded(
                            child: new Text(
                              'Select your desired campus',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  )),
              new Padding(padding: EdgeInsets.all(3)),
              FormField<int>(
                builder: (
                  FormFieldState<int> state,
                ) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new InputDecorator(
                        decoration: InputDecoration(
                            labelText: 'Campus',
                            contentPadding: EdgeInsets.only(
                                left: 10.0, top: 5.0, bottom: 5.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                            errorText: state.hasError ? state.errorText : null),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                            isExpanded: true,
                            hint: new Text('Select Campus'),
                            value: _selectedCampus,
                            style:
                                TextStyle(color: Colors.black, fontSize: 12.0),
                            onChanged: (int newValue) {
                              setState(() {
                                _selectedCampus = newValue;
                                _selectedClass = null;
                              });
                              state.didChange(newValue);
                              _loadDropdownClass(_selectedCampus);
                              _selectedCampusName = osrListCampus
                                  .where((i) => i.id == _selectedCampus)
                                  .map((f) => f.name)
                                  .toString();
                            },
                            items: osrListCampus.map((value) {
                              return new DropdownMenuItem<int>(
                                value: value.id,
                                child: new Text(value.address),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  );
                },
                validator: (value) {
                  if (_selectedCampus == null) {
                    return 'This Field is Required';
                  }
                  return null;
                },
                onSaved: (value) {
                  _selectedCampus = value;
                },
              ),
              new Padding(padding: EdgeInsets.only(top: 10)),
              new Container(
                  margin: EdgeInsets.only(left: 2),
                  child: Column(
                    children: <Widget>[
                      new Row(
                        children: <Widget>[
                          Expanded(
                            child: new Text(
                              'To which class is admission required?',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  )),
              new Padding(padding: EdgeInsets.all(3)),
              FormField<int>(
                builder: (
                  FormFieldState<int> state,
                ) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new InputDecorator(
                        decoration: InputDecoration(
                            labelText: 'Class',
                            contentPadding: EdgeInsets.only(
                                left: 10.0, top: 5.0, bottom: 5.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                            errorText: state.hasError ? state.errorText : null),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                            isExpanded: true,
                            hint: new Text('Select Class'),
                            value: _selectedClass,
                            onChanged: (int newValue) {
                              setState(() {
                                _selectedClass = newValue;
                              });
                              state.didChange(newValue);
                              _selectedClassName = osrListClass
                                  .where((i) => i.id == _selectedClass)
                                  .map((f) => f.name)
                                  .toString();
                            },
                            items: osrListClass.map((value) {
                              return new DropdownMenuItem<int>(
                                value: value.id,
                                child: new Text(value.name),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  );
                },
                validator: (value) {
                  if (_selectedClass == null) {
                    return 'This Field is Required';
                  }
                  return null;
                },
                onSaved: (value) {
                  setState(() {
                    _selectedClass = value;
                  });
                },
              ),
              new Padding(padding: EdgeInsets.only(top: 10)),
              new Container(
                  margin: EdgeInsets.only(left: 2),
                  child: Column(
                    children: <Widget>[
                      new Row(
                        children: <Widget>[
                          Expanded(
                            child: new RichText(
                              text: new TextSpan(
                                style: new TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                ),
                                children: <TextSpan>[
                                  new TextSpan(
                                      text:
                                          'Registration Fee Payable: Rs 600-750.',
                                      style: new TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromRGBO(
                                              48, 63, 159, 1.0))),
                                  new TextSpan(
                                      text:
                                          'Bank convenience fee will be charged on card payments.'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      new Padding(padding: EdgeInsets.all(5)),
                      new Container(
                          margin: EdgeInsets.only(left: 2, top: 15),
                          child: Column(
                            children: <Widget>[
                              new Row(
                                children: <Widget>[
                                  Expanded(
                                    child: new Text(
                                      'Has the child attended any school before?',
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          )),
                      new Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            new Radio(
                              value: 0,
                              groupValue: _radioValuePreviousSchool,
                              onChanged: _handlePreviousEduRadioValueChange,
                            ),
                            new Text(
                              'Yes',
                              style: new TextStyle(fontSize: 16.0),
                            ),
                            new Padding(padding: EdgeInsets.only(right: 10)),
                            new Radio(
                              value: 1,
                              groupValue: _radioValuePreviousSchool,
                              onChanged: _handlePreviousEduRadioValueChange,
                            ),
                            new Text(
                              'No',
                              style: new TextStyle(fontSize: 16.0),
                            ),
                          ]),
                    ],
                  )),
            ],
          ),
        ),
        state: _getState(1),
        isActive: stepCounter >= 1,
      ),
      //Step 3
      Step(
        title: Text('Previous School', style: TextStyle(fontSize: 20.0)),
        content: Form(
            key: _formKeys[2],
            autovalidate: _autoValidate2,
            child: new Container(
              child: Column(
                children: <Widget>[
                  new Padding(padding: EdgeInsets.all(3)),
                  new TextFormField(
                    onFieldSubmitted: (String value) {
                      FocusScope.of(context).requestFocus(psLocationNode);
                    },
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    controller: previousSchoolController,
                    decoration: InputDecoration(
                        labelText: 'Previous School Name',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter Your Previous School Name';
                      }
                      return null;
                    },
                    onSaved: (String val) {
                      previousSchoolController.text = val;
                    },
                  ),
                  new Padding(padding: EdgeInsets.all(3)),
                  new TextFormField(
                    focusNode: psLocationNode,
                    controller: pSLocationController,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                    keyboardType: TextInputType.text,
                    onFieldSubmitted: (String value) {
                      FocusScope.of(context).requestFocus(studiedFromClassNode);
                    },
                    onSaved: (String val) {
                      pSLocationController.text = val;
                    },
                    decoration: InputDecoration(
                        labelText: 'Previous School Location',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter Your Previous School Location';
                      }
                      return null;
                    },
                  ),
                  new Padding(padding: EdgeInsets.all(3)),
                  new TextFormField(
                    focusNode: studiedFromClassNode,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    controller: studiedFromClassController,
                    textCapitalization: TextCapitalization.words,
                    onFieldSubmitted: (String value) {
                      FocusScope.of(context).requestFocus(studiedToClassNode);
                    },
                    onSaved: (String val) {
                      studiedFromClassController.text = val;
                    },
                    decoration: InputDecoration(
                        labelText: 'Studied From Class',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter Your Studied From Class';
                      }
                      return null;
                    },
                  ),
                  new Padding(padding: EdgeInsets.all(3)),
                  new TextFormField(
                    focusNode: studiedToClassNode,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    controller: studiedToClassController,
                    textCapitalization: TextCapitalization.words,
                    onFieldSubmitted: (String value) {
                      FocusScope.of(context).requestFocus(rxnForLeavingNode);
                    },
                    onSaved: (String val) {
                      studiedToClassController.text = val;
                    },
                    decoration: InputDecoration(
                        labelText: 'Studied To Class',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter Your Studied To Class';
                      }
                      return null;
                    },
                  ),
                  new Padding(padding: EdgeInsets.all(3)),
                  new TextFormField(
                    focusNode: rxnForLeavingNode,
                    keyboardType: TextInputType.text,
                    controller: leavingRxnController,
                    textCapitalization: TextCapitalization.words,
                    onSaved: (String val) {
                      leavingRxnController.text = val;
                    },
                    decoration: InputDecoration(
                        labelText: 'Reason For Leaving',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter Reason For Leaving';
                      }
                      return null;
                    },
                  ),
                  new Padding(padding: EdgeInsets.only(top: 15.0)),
                ],
              ),
            )),
        state: _getState(2),
        isActive: stepCounter >= 2,
      ),
      //Step 4
      Step(
        title: Text('Guardian', style: TextStyle(fontSize: 20.0)),
        content: Form(
            key: _formKeys[3],
            autovalidate: _autoValidate3,
            child: new Container(
              child: Column(
                children: <Widget>[
                  new Padding(padding: EdgeInsets.all(3)),
                  new TextFormField(
                    onFieldSubmitted: (String value) {
                      FocusScope.of(context).requestFocus(fatherCNICNode);
                    },
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    controller: fatherNameController,
                    decoration: InputDecoration(
                        labelText: 'Father’s/Guardian’s Name',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter Father’s/Guardian’s Name';
                      }
                      return null;
                    },
                    onSaved: (String val) {
                      fatherNameController.text = val;
                    },
                  ),
                  new Padding(padding: EdgeInsets.all(3)),
                  new TextFormField(
                    focusNode: fatherCNICNode,
                    controller: fatherCNICController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    onFieldSubmitted: (String value) {
                      FocusScope.of(context).requestFocus(fatherOccupationNode);
                    },
                    onSaved: (String val) {
                      fatherCNICController.text = val;
                    },
                    decoration: InputDecoration(
                        labelText: 'Father’s/Guardian’s CNIC No',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter Father’s/Guardian’s CNIC No';
                      } else if (value.length < 15) {
                        return 'Enter Valid CNIC No';
                      }
                      return null;
                    },
                  ),
                  new Padding(padding: EdgeInsets.all(3)),
                  new TextFormField(
                    focusNode: fatherOccupationNode,
                    controller: fatherOccupationController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.words,
                    onFieldSubmitted: (String value) {
                      FocusScope.of(context).requestFocus(fatherMobileNoNode);
                    },
                    onSaved: (String val) {
                      fatherOccupationController.text = val;
                    },
                    decoration: InputDecoration(
                        labelText: 'Father’s/Guardian’s Occupation',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter Father’s/Guardian’s Occupation';
                      }
                      return null;
                    },
                  ),
                  new Padding(padding: EdgeInsets.all(3)),
                  new TextFormField(
                    focusNode: fatherMobileNoNode,
                    keyboardType: TextInputType.phone,
                    controller: mobileNumberController,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (String value) {
                      FocusScope.of(context).requestFocus(fatherEmailNode);
                    },
                    onSaved: (String val) {
                      mobileNumberController.text = val;
                    },
                    decoration: InputDecoration(
                        labelText: 'Father’s/Guardian’s Mobile Number',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter Father’s/Guardian’s Mobile Number';
                      }
                      return null;
                    },
                  ),
                  new Padding(padding: EdgeInsets.all(3)),
                  new TextFormField(
                    focusNode: fatherEmailNode,
                    controller: emailAddressController,
                    keyboardType: TextInputType.emailAddress,
                    onSaved: (String val) {
                      emailAddressController.text = val;
                    },
                    decoration: InputDecoration(
                        labelText: 'Father’s/Guardian’s Email Address',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                    validator: (value) {
                      RegExp regex = new RegExp(pattern);
                      if (value.isEmpty) {
                        return 'Enter Father’s/Guardian’s Email Address';
                      } else if (!regex.hasMatch(value)) {
                        return 'Enter Valid Email Address';
                      }
                      return null;
                    },
                  ),
                  new Padding(padding: EdgeInsets.only(top: 15.0)),
                ],
              ),
            )),
        state: _getState(3),
        isActive: stepCounter >= 3,
      ),
    ];
    return Scaffold(
        key: scaffoldKey,
        appBar: new AppBar(
          elevation: 0.0,
          centerTitle: true,
          backgroundColor: Color.fromRGBO(48, 63, 159, 1.0),
          title: new Text(
            'Online Student Registration',
            style: TextStyle(fontSize: 20.0, fontStyle: FontStyle.italic),
          ),
        ),
        body: isLoading
            ? Center(
                child: new Container(
                child: Platform.isAndroid
                    ? CircularProgressIndicator(
                        strokeWidth: 4.0,
                      )
                    : CupertinoActivityIndicator(
                        radius: 20,
                      ),
              ))
            : this.connected == false
                ? new Center(
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Icon(
                          Icons.signal_wifi_off,
                          color: Colors.grey,
                          size: 80.0,
                        ),
                        new Text(
                          'No Internet Connection',
                          style: TextStyle(color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                        new Padding(padding: EdgeInsets.only(top: 5.0)),
                        new CupertinoButton(
                          color: Colors.grey,
                          pressedOpacity: 0.8,
                          child: new Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Icon(
                                Icons.refresh,
                                color: Colors.white,
                                size: 25.0,
                              ),
                              new Text(
                                'Tap to Refresh',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                          onPressed: () => initState(),
                        ),
                      ],
                    ),
                  )
                : this.isSuccessful == false
                    ? Container(
                        child: Stepper(
                          currentStep: this.stepCounter,
                          steps: steps,
                          type: StepperType.vertical,
                          controlsBuilder: (BuildContext context,
                              {VoidCallback onStepContinue,
                              VoidCallback onStepCancel}) {
                            return Row(
                              children: <Widget>[
                                stepCounter == 3
                                    ? RaisedButton(
                                        color: Colors.lightGreen,
                                        onPressed: _onSave,
                                        child: const Text(
                                          'SAVE',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      )
                                    : RaisedButton(
                                        color: Colors.lightGreen,
                                        onPressed: onStepContinue,
                                        child: const Text(
                                          'NEXT',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                new Padding(padding: EdgeInsets.all(15.0)),
                                stepCounter == 0
                                    ? new Container()
                                    : RaisedButton(
                                        onPressed: onStepCancel,
                                        child: const Text('BACK'),
                                      ),
                              ],
                            );
                          },
                          onStepCancel: () {
                            setState(() {
                              if (stepCounter == 3) {
                                if (_radioValuePreviousSchool == 0) {
                                  stepCounter--;
                                } else if (_radioValuePreviousSchool == 1) {
                                  stepCounter -= 2;
                                }
                              } else {
                                stepCounter--;
                              }
                            });
                          },
                          onStepContinue: () {
                            SystemChannels.textInput
                                .invokeMethod('TextInput.hide');
                            setState(() {
                              final form = _formKeys[stepCounter].currentState;
                              if (form.validate()) {
                                if (stepCounter == 0) {
                                  if (_radioValueGender == -1) {
                                    final snackBar = new SnackBar(
                                      content:
                                          new Text('Please Select Your Gender'),
                                      duration:
                                          new Duration(milliseconds: 1000),
                                    );
                                    scaffoldKey.currentState
                                        .showSnackBar(snackBar);
                                  } else {
                                    form.save();
                                    stepCounter++;
                                  }
                                } else if (stepCounter == 1) {
                                  print(_autoValidate);
                                  if (_radioValuePreviousSchool == 0) {
                                    stepCounter++;
                                  } else if (_radioValuePreviousSchool == 1) {
                                    stepCounter += 2;
                                  } else if (_radioValuePreviousSchool == -1) {
                                    final snackBar = new SnackBar(
                                      content: new Text(
                                          'Please Select Previous School History'),
                                      duration:
                                          new Duration(milliseconds: 1000),
                                    );
                                    scaffoldKey.currentState
                                        .showSnackBar(snackBar);
                                  }
                                  form.save();
                                } else {
                                  form.save();
                                  stepCounter++;
                                }
                              } else {
                                setState(() {
                                  if (stepCounter == 0) {
                                    setState(() {
                                      _autoValidate = true;
                                    });
                                  } else if (stepCounter == 1) {
                                    setState(() {
                                      _autoValidate1 = true;
                                    });
                                  } else if (stepCounter == 2) {
                                    setState(() {
                                      _autoValidate2 = true;
                                    });
                                  }
                                });
                              }
                            });
                          },
                        ),
                      )
                    : Center(
                        child: Column(children: <Widget>[
                        new Container(
                          child: Center(
                            child: Column(
                              children: <Widget>[
                                new Padding(padding: EdgeInsets.all(5.0)),
                                new Image.asset(
                                  'images/icon_success.png',
                                  height:
                                      MediaQuery.of(context).size.height / 10,
                                  width: MediaQuery.of(context).size.width / 7,
                                ),
                                new Container(
                                  padding: EdgeInsets.all(5.0),
                                  child: new Text(
                                    'Thank you for submitting the Online Student Registration Form. The details you have provided have been forwarded to the relevant Campus and Regional Office. Please pay Registration fee by any method below:',
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                ),
                                new Container(
                                  padding: EdgeInsets.all(5.0),
                                  child: new FlatButton(
                                    onPressed: _payOnline,
                                    child: new Text(
                                      'Pay Registration Fee Online',
                                      style: TextStyle(
                                          color:
                                              Color.fromRGBO(48, 63, 159, 1.0),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                new Container(
                                  padding: EdgeInsets.all(5.0),
                                  child: new Text(
                                    'Or',
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                ),
                                new Container(
                                  padding: EdgeInsets.all(15.0),
                                  child: new Text(
                                    'Pay by Visiting the School(Give Reference: 39176)',
                                    style: TextStyle(
                                        color: Color.fromRGBO(48, 63, 159, 1.0),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                new Container(
                                  padding: EdgeInsets.all(5.0),
                                  child: new RichText(
                                    text: new TextSpan(
                                      children: <TextSpan>[
                                        new TextSpan(
                                            text: 'Note: ',
                                            style: new TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black)),
                                        new TextSpan(
                                          text:
                                              'The submission of this online form only means that the child’s application has been registered. It does not guarantee admission.',
                                          style:
                                              TextStyle(color: Colors.black54),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ])));
  }

  Future _saveFormRequest() async {
    try {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      var connectivityResult = await (new Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        setState(() {
          isLoading = true;
        });
        DateTime dateTime = DateTime.parse(yearController.text +
            '-' +
            monthController.text.padLeft(2, '0') +
            '-' +
            dayController.text.padLeft(2, '0'));
        _dateOfBirth = formatDate.format(dateTime);
        OSRRegistrationModel regInfo = new OSRRegistrationModel(
            info: Info(
          firstName: nameController.text,
          surName: surNameController.text,
          gender: gender,
          dOB: _dateOfBirth,
          nationality: _nationality,
          admissionRequiredSession: _selectedSessionName,
          city: _selectedCityName,
          branchCode: _selectedCampusName,
          classId: _selectedClassName,
          previousSchoolName: previousSchoolController.text,
          previousSchoolLocation: pSLocationController.text,
          studiedFromClass: studiedFromClassController.text,
          studiedToClass: studiedToClassController.text,
          reasonForLeaving: leavingRxnController.text,
          guardianName: fatherNameController.text,
          guardianCNIC: fatherCNICController.text,
          guardianOccupation: fatherOccupationController.text,
          guardianContactNumber: mobileNumberController.text,
          guardianEmail: emailAddressController.text,
        ));

        http.Response response = await http.post('${AppConstants.apiBaseURL}/OSR/AddRegistration',
            body: json.encode(regInfo.toJson()),
            headers: {
              'content-type': 'application/json'
            }).timeout(Duration(minutes: 2));
        var responseData = json.decode(response.body);
        OSRRegResponseModel registrationModel =
            new OSRRegResponseModel.fromJson(responseData);
        setState(() {
          isSuccessful = registrationModel.isSuccessful;
          // _message = registrationModel.message;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        final snackBar = new SnackBar(
          content: new Text('Connect your internet'),
          duration: new Duration(milliseconds: 1000),
        );
        scaffoldKey.currentState.showSnackBar(snackBar);
      }
    } catch (exception) {
      setState(() {
        isLoading = false;
      });
      final snackBar = new SnackBar(
        content: new Text(exception.toString()),
        duration: new Duration(milliseconds: 10000),
      );
      scaffoldKey.currentState.showSnackBar(snackBar);
    }
  }

  _onSave() {
    setState(() {
      final form = _formKeys[stepCounter].currentState;
      if (form.validate()) {
        form.save();
        _saveFormRequest();
      } else {
        setState(() {
          _autoValidate3 = true;
        });
      }
    });
  }

  _payOnline() {
    print('Pay');
  }
}
*/
