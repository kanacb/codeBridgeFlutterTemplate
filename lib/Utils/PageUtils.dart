import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Services/Schema.dart';
import 'Validators.dart';

class Utils {
  Route createRoute(context, Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  Widget buildField(Schema field, dynamic formData , BuildContext context ,  setState) {
    print(field.type);
    print(field.field);
    switch (field.type?.toLowerCase()) {
      case 'objectid':
        if (field.field == "createdBy") {
          return const SizedBox.shrink();
        } else if (field.field == "updatedBy") {
          return const SizedBox.shrink();
        } else {
          return buildTextField(field, (value) {
            formData[field.field] = value;
          }, '');
        }
      case 'string':
        if(field.field == "updatedAt") {
          return const SizedBox.shrink();
        }
        else {
          return buildTextField(field, (value) {
            formData[field.field] = value;
          }, '');
        }
      case 'number':
        return buildNumberField(field, formData, (value) {
          formData[field.field] = value;
        }, 0);
      case 'bool':
        return buildCheckbox(field, formData, (value) {
          formData[field.field] = value;
        }, false);

      case 'date':
        if (field.field == "createdAt") {
          return const SizedBox.shrink();
        } else {
          void onSetDate(value) {
            setState(() {
              formData[field.field] = value;
            });
          }

          return buildDateField(
              field, formData, context, onSetDate, DateTime.now());
        }
      default:
        return const SizedBox.shrink();
    }
  }

  Widget buildNumberField(
      Schema schema, formData, onChanged, double initialValue) {
    return TextFormField(
      initialValue: initialValue.toString(),
      keyboardType: TextInputType.number,
      autovalidateMode: AutovalidateMode.always,
      decoration: InputDecoration(
        hintText: 'Enter ${schema.label}',
        labelText: schema.label,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            borderSide: BorderSide(color: Colors.blue)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            borderSide: BorderSide(color: Colors.red)),
      ),
      onChanged: onChanged,
      validator: (value) {
        if (!Validators.isStringNotEmpty(value)) {
          return null;
        }
        return "Please enter valid ${schema.label}";
      },
    );
  }

  Widget buildTextField(Schema schema, onChanged, String? initialValue) {
    return TextFormField(
        initialValue: initialValue,
        keyboardType: TextInputType.text,
        autovalidateMode: AutovalidateMode.always,
        decoration: InputDecoration(
            border: UnderlineInputBorder(),
            hintText: 'Enter ${schema.label}',
            labelText: schema.label,
            labelStyle: TextStyle(fontWeight: FontWeight.bold)),
        validator: (value) {
          if (Validators.isStringNotEmpty(value)) {
            return null;
          }
          return "Please enter valid ${schema.label}";
        },
        onChanged: onChanged);
  }

  Widget buildMultiLineField(Schema schema, onChanged, String? initialValue) {
    return TextFormField(
        initialValue: initialValue,
        keyboardType: TextInputType.multiline,
        autovalidateMode: AutovalidateMode.always,
        decoration: InputDecoration(
            border: UnderlineInputBorder(),
            hintText: 'Enter ${schema.label}',
            labelText: schema.label,
            labelStyle: TextStyle(fontWeight: FontWeight.bold)),
        validator: (value) {
          if (Validators.isStringNotEmpty(value)) {
            return null;
          }
          return "Please enter valid ${schema.label}";
        },
        onChanged: onChanged);
  }

  Widget buildPhoneField(Schema schema, onChanged, String? initialValue) {
    return TextFormField(
        initialValue: initialValue,
        keyboardType: TextInputType.phone,
        autovalidateMode: AutovalidateMode.always,
        decoration: InputDecoration(
            border: UnderlineInputBorder(),
            hintText: 'Enter ${schema.label}',
            labelText: schema.label,
            labelStyle: TextStyle(fontWeight: FontWeight.bold)),
        validator: (value) {
          if (Validators.isStringNotEmpty(value)) {
            return null;
          }
          return "Please enter valid ${schema.label}";
        },
        onChanged: onChanged);
  }

  Widget buildUrlField(Schema schema, onChanged, String? initialValue) {
    return TextFormField(
        initialValue: initialValue,
        keyboardType: TextInputType.url,
        autovalidateMode: AutovalidateMode.always,
        decoration: InputDecoration(
            border: UnderlineInputBorder(),
            hintText: 'Enter ${schema.label}',
            labelText: schema.label,
            labelStyle: TextStyle(fontWeight: FontWeight.bold)),
        validator: (value) {
          if (Validators.isStringNotEmpty(value)) {
            return null;
          }
          return "Please enter valid ${schema.label}";
        },
        onChanged: onChanged);
  }

  Widget buildStreetAddressField(
      Schema schema, onChanged, String? initialValue) {
    return TextFormField(
        initialValue: initialValue,
        keyboardType: TextInputType.streetAddress,
        autovalidateMode: AutovalidateMode.always,
        decoration: InputDecoration(
            border: UnderlineInputBorder(),
            hintText: 'Enter ${schema.label}',
            labelText: schema.label,
            labelStyle: TextStyle(fontWeight: FontWeight.bold)),
        validator: (value) {
          if (Validators.isStringNotEmpty(value)) {
            return null;
          }
          return "Please enter valid ${schema.label}";
        },
        onChanged: onChanged);
  }

  Widget buildDecimalNumberField(
      Schema schema, onChanged, String? initialValue) {
    return TextFormField(
        initialValue: initialValue,
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        autovalidateMode: AutovalidateMode.always,
        decoration: InputDecoration(
            border: UnderlineInputBorder(),
            hintText: 'Enter ${schema.label}',
            labelText: schema.label,
            labelStyle: TextStyle(fontWeight: FontWeight.bold)),
        validator: (value) {
          if (Validators.isStringNotEmpty(value)) {
            return null;
          }
          return "Please enter valid ${schema.label}";
        },
        onChanged: onChanged);
  }

  Widget buildNegavitesNumberField(
      Schema schema, onChanged, String? initialValue) {
    return TextFormField(
        initialValue: initialValue,
        keyboardType: TextInputType.numberWithOptions(signed: true),
        autovalidateMode: AutovalidateMode.always,
        decoration: InputDecoration(
            border: UnderlineInputBorder(),
            hintText: 'Enter ${schema.label}',
            labelText: schema.label,
            labelStyle: TextStyle(fontWeight: FontWeight.bold)),
        validator: (value) {
          if (Validators.isStringNotEmpty(value)) {
            return null;
          }
          return "Please enter valid ${schema.label}";
        },
        onChanged: onChanged);
  }

  Widget buildEmailField(
      Schema schema, ValueChanged<String> onChanged, String? initialValue) {
    return TextFormField(
        initialValue: initialValue,
        keyboardType: TextInputType.text,
        autovalidateMode: AutovalidateMode.always,
        decoration: InputDecoration(
            hintText: 'Enter ${schema.label}',
            labelText: schema.label,
            labelStyle: TextStyle(fontWeight: FontWeight.bold)),
        validator: (value) {
          if (Validators.isEmail(value)) {
            return null;
          }
          return "Please enter valid ${schema.label}";
        },
        onChanged: onChanged);
  }

  Widget buildPasswordField(
      Schema schema, ValueChanged<String> onChanged, String? initialValue) {
    return TextFormField(
        obscureText: true,
        initialValue: initialValue,
        keyboardType: TextInputType.text,
        autovalidateMode: AutovalidateMode.always,
        decoration: InputDecoration(
            hintText: 'Enter ${schema.label}',
            labelText: schema.label,
            labelStyle: TextStyle(fontWeight: FontWeight.bold)),
        validator: (value) {
          if (Validators.isEmail(value)) {
            return null;
          }
          return "Please enter valid ${schema.label}";
        },
        onChanged: onChanged);
  }

  Widget buildCheckbox(Schema schema, formData, onChange, bool initialValue) {
    return CheckboxListTile(
        title: Text(schema.label ?? "unknown"), value: initialValue, onChanged: onChange);
  }

  List<Widget> buildCheckboxArray(Schema schema, formData, onChange, bool initialValue) {
    List values = formData[schema.field];
    return values.map((toElement) {
      return CheckboxListTile(
          title: Text(toElement ?? "unknown"),
          value: initialValue,
          onChanged: onChange);
    }).toList();

  }

  Widget buildDateField(Schema schema, formData, context, Function onSetDate,
      DateTime initialDate) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () async {
          DateTime? selectedDate = await showDatePicker(
            context: context,
            initialDate: initialDate,
            firstDate: DateTime(1999),
            lastDate: DateTime(2100),
          );
          if (selectedDate != null) {
            onSetDate(selectedDate);
          }
        },
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: schema.label,
            border: OutlineInputBorder(),
          ),
          child: Text(
            formData[schema.field] != null
                ? formData[schema.field].toString().split(' ')[0]
                : 'Select a date',
          ),
        ),
      ),
    );
  }

  Widget iconType(String? type) {
    switch (type?.toLowerCase()) {
      case "number":
        return Icon(Icons.numbers);
      case "date":
        return Icon(Icons.date_range);
      case "boolean":
        return Icon(Icons.done);
      case "string":
        return Icon(Icons.abc);
      default:
        return Icon(Icons.abc);
    }
  }

  Widget buildDropdownButton(BuildContext context, List<String>? list,
      ValueChanged<String?>? onChanged, String? selected) {
    String? dropdownValue = selected ?? list?.first;

    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_drop_down),
      elevation: 16,
      style: const TextStyle(color: Colors.grey),
      underline: Container(
        height: 2,
        color: Colors.black12,
      ),
      onChanged: onChanged,
      hint: Text("select a value"),
      autofocus: true,
      isExpanded: true,
      items: list?.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
