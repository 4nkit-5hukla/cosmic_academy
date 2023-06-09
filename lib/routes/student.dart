import 'package:cosmic_assessments/view/screens/student/courses.dart';
import 'package:cosmic_assessments/view/screens/student/landing.dart';
import 'package:cosmic_assessments/view/screens/student/meetings.dart';
import 'package:cosmic_assessments/view/screens/student/tests/quiz_run.dart';
import 'package:cosmic_assessments/view/screens/student/tests/start_test.dart';
import 'package:cosmic_assessments/view/screens/student/tests/test_submissions.dart';
import 'package:cosmic_assessments/view/screens/student/tests/test_details.dart';
import 'package:cosmic_assessments/view/screens/student/tests/test_report.dart';
import 'package:cosmic_assessments/view/screens/student/tests/test_run.dart';
import 'package:cosmic_assessments/view/screens/student/tests/tests.dart';
import 'package:get/get.dart';

class StudentRoutes {
  static List<GetPage> routes = [
    GetPage(
      page: () => const StudentLandingScreen(
        title: 'Home',
      ),
      name: StudentLandingScreen.routeName,
    ),
    GetPage(
      page: () => const StudentBrowseTests(
        title: 'Browse Tests',
        useBack: true,
      ),
      name: StudentBrowseTests.routeName,
    ),
    GetPage(
      page: () => const StudentTestDetails(
        title: 'Test Details',
      ),
      name: StudentTestDetails.routeName,
    ),
    GetPage(
      page: () => const StudentTestSubmissionsScreen(
        title: 'Test Submissions',
      ),
      name: StudentTestSubmissionsScreen.routeName,
    ),
    GetPage(
      page: () => const StudentTestReportScreen(
        title: 'Test Report',
      ),
      name: StudentTestReportScreen.routeName,
    ),
    GetPage(
      page: () => const StudentStartTestScreen(
        title: 'Start Test',
      ),
      name: StudentStartTestScreen.routeName,
    ),
    GetPage(
      page: () => const StudentTestRunScreen(),
      name: StudentTestRunScreen.routeName,
    ),
    GetPage(
      page: () => const StudentQuizRunScreen(),
      name: StudentQuizRunScreen.routeName,
    ),
    GetPage(
      page: () => const StudentMeetingsList(
        title: 'Online Classes',
      ),
      name: StudentMeetingsList.routeName,
    ),
    GetPage(
      page: () => const StudentCoursesScreen(
        title: 'My Courses',
      ),
      name: StudentCoursesScreen.routeName,
    ),
  ];
}
