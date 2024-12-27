import 'dart:async';
import 'package:rxdart/rxdart.dart';

class JobPostBloc {
  // Input controllers
  final _jobTitleController = BehaviorSubject<String>();
  final _locationController = BehaviorSubject<String>();
  final _workingDaysController = BehaviorSubject<String>();
  final _tempWorkingDaysController = BehaviorSubject<String>();
  final _salaryController = BehaviorSubject<String>();
  final _descriptionController = BehaviorSubject<String>();

  // Getters for adding data to stream
  Function(String) get updateJobTitle => _jobTitleController.sink.add;
  Function(String) get updateLocation => _locationController.sink.add;
  Function(String) get updateWorkingDays => _workingDaysController.sink.add;
  Function(String) get updateTempWorkingDays =>
      _tempWorkingDaysController.sink.add;
  Function(String) get updateSalary => _salaryController.sink.add;
  Function(String) get updateDescription => _descriptionController.sink.add;

  // Stream getters
  Stream<bool> get isFormValid => Rx.combineLatest7(
        _jobTitleController.stream,
        _locationController.stream,
        _workingDaysController.stream,
        _tempWorkingDaysController.stream,
        _salaryController.stream,
        _descriptionController.stream,
        _workingDaysController.stream
            .map((workingDays) => workingDays == 'Temporary'),
        (jobTitle, location, workingDays, tempDays, salary, description,
            isTemporary) {
          // Check if job title is valid (not empty and not 'Select')
          bool isJobTitleValid = jobTitle.isNotEmpty && jobTitle != 'Select';

          // Check if location is valid
          bool isLocationValid = location.isNotEmpty;

          // Check if working days selection is valid
          bool isWorkingDaysValid =
              workingDays.isNotEmpty && workingDays != 'Select';

          // For temporary working days, validate the number of days
          bool isTempDaysValid = !isTemporary ||
              (isTemporary &&
                  tempDays.isNotEmpty &&
                  int.tryParse(tempDays) != null);

          // Validate salary (should be a valid number)
          bool isSalaryValid =
              salary.isNotEmpty && double.tryParse(salary) != null;

          // Check if description is not empty
          bool isDescriptionValid = description.isNotEmpty;

          // Return true only if all validations pass
          return isJobTitleValid &&
              isLocationValid &&
              isWorkingDaysValid &&
              isTempDaysValid &&
              isSalaryValid &&
              isDescriptionValid;
        },
      );

  void dispose() {
    _jobTitleController.close();
    _locationController.close();
    _workingDaysController.close();
    _tempWorkingDaysController.close();
    _salaryController.close();
    _descriptionController.close();
  }
}
