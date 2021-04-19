import 'package:bloc/bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'flit_bundle.dart';
import 'flit_state.dart';

abstract class FlitViewModel<T> extends Cubit<T> {
  FlitViewModel(T state) : super(state);
  void init(FlitBundle bundle) {}
}

abstract class FlitBaseFormConfig {
  final Map<String, BaseFormElement> formElements;
  final FormGroup form;
  FlitBaseFormConfig(this.formElements) : form = buildForm(formElements);

  static FormGroup buildForm(Map<String, dynamic> formElements) {
    return fb.group(formElements.map((key, value) {
      if (value is FormElementMap) {
        return MapEntry(key, buildForm(value.elements));
      } else {
        return MapEntry(key, value.control);
      }
    }));
  }
}

class BaseFormElement {}

class FormElement<MODEL, TYPE, CTYPE> extends BaseFormElement {
  final CTYPE control;
  final MODEL Function(dynamic model, dynamic type)? variableAssignToModel;
  final dynamic Function(dynamic model, dynamic control)? assignModelToForm;

  FormElement(
      {required this.control,
      this.variableAssignToModel,
      this.assignModelToForm});
}

class FormElementMap<MODEL> extends BaseFormElement {
  final Map<String, BaseFormElement> elements;
  FormElementMap(this.elements);
}

abstract class FlitFormViewModel<MODEL, STATE extends FlitState,
    FORM extends FlitBaseFormConfig> extends FlitViewModel<STATE> {
  final FORM formConfig;
  late MODEL formModel;

  FlitFormViewModel(STATE state, this.formConfig) : super(state);

  ///
  /// Function to load data to the form
  /// to be called at startup of the viewmodel
  void loadForm(MODEL model) {
    loadValues(model, formConfig.formElements);
    this.formModel = model;
  }

  ///
  /// Function to check data from form
  ///
  Future<bool> checkFormBeforeSubmit() async {
    assignValues(formConfig.formElements);
    return true;
  }

  void assignValues(Map<String, BaseFormElement> formElements) {
    formElements.forEach((key, value) {
      if (value is FormElementMap) {
        assignValues(value.elements);
      } else if (value is FormElement && value.variableAssignToModel != null)
        formModel =
            value.variableAssignToModel!(formModel, value.control.value);
      //logger.d("$key -> ${value.control.value}");
    });
  }

  void loadValues(MODEL model, Map<String, BaseFormElement> formElements) {
    formElements.forEach((key, value) {
      if (value is FormElementMap) {
        loadValues(model, value.elements);
      } else if (value is FormElement) {
        if (value.assignModelToForm != null)
          value.assignModelToForm!(model, value.control);
        //logger.d("$key -> ${value.control.value}");
      }
    });
  }
}
