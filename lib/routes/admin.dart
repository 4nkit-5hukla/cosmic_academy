import 'package:cosmic_assessments/view/pop_ups/admin/courses/add_course.dart';
import 'package:cosmic_assessments/view/pop_ups/admin/courses/edit_course.dart';
import 'package:cosmic_assessments/view/pop_ups/admin/lessons/add_lesson.dart';
import 'package:cosmic_assessments/view/pop_ups/admin/lessons/add_lesson_content.dart';
import 'package:cosmic_assessments/view/pop_ups/admin/lessons/add_lesson_section.dart';
import 'package:cosmic_assessments/view/pop_ups/admin/lessons/edit_lesson.dart';
import 'package:cosmic_assessments/view/pop_ups/admin/lessons/edit_lesson_content.dart';
import 'package:cosmic_assessments/view/pop_ups/admin/lessons/preview_content.dart';
import 'package:cosmic_assessments/view/pop_ups/admin/meetings/add_meeting.dart';
import 'package:cosmic_assessments/view/pop_ups/admin/meetings/edit_meeting.dart';
import 'package:cosmic_assessments/view/pop_ups/admin/tests/add_enrollment.dart';
import 'package:cosmic_assessments/view/pop_ups/admin/tests/add_question.dart';
import 'package:cosmic_assessments/view/pop_ups/admin/tests/add_test.dart';
import 'package:cosmic_assessments/view/pop_ups/admin/tests/bulk_upload_questions.dart';
import 'package:cosmic_assessments/view/pop_ups/admin/tests/edit_question.dart';
import 'package:cosmic_assessments/view/pop_ups/admin/tests/edit_test.dart';
import 'package:cosmic_assessments/view/pop_ups/admin/users/add_user.dart';
import 'package:cosmic_assessments/view/pop_ups/admin/users/edit_user.dart';
import 'package:cosmic_assessments/view/screens/admin/admin_settings.dart';
import 'package:cosmic_assessments/view/screens/admin/assignments.dart';
import 'package:cosmic_assessments/view/screens/admin/courses/courses.dart';
import 'package:cosmic_assessments/view/screens/admin/courses/manage_course.dart';
import 'package:cosmic_assessments/view/screens/admin/landing.dart';
import 'package:cosmic_assessments/view/screens/admin/lessons/lessons.dart';
import 'package:cosmic_assessments/view/screens/admin/lessons/view_lesson.dart';
import 'package:cosmic_assessments/view/screens/admin/lessons/view_section.dart';
import 'package:cosmic_assessments/view/screens/admin/meetings/meetings.dart';
import 'package:cosmic_assessments/view/screens/admin/meetings/share_meeting.dart';
import 'package:cosmic_assessments/view/screens/admin/meetings/view_meeting.dart';
import 'package:cosmic_assessments/view/screens/admin/qna.dart';
import 'package:cosmic_assessments/view/screens/admin/tests/enrollments.dart';
import 'package:cosmic_assessments/view/screens/admin/tests/manage_test.dart';
import 'package:cosmic_assessments/view/screens/admin/tests/questions.dart';
import 'package:cosmic_assessments/view/screens/admin/tests/start_test.dart';
import 'package:cosmic_assessments/view/screens/admin/tests/test_report.dart';
import 'package:cosmic_assessments/view/screens/admin/tests/test_run.dart';
import 'package:cosmic_assessments/view/screens/admin/tests/test_settings.dart';
import 'package:cosmic_assessments/view/screens/admin/tests/test_submissions.dart';
import 'package:cosmic_assessments/view/screens/admin/tests/test_submitted.dart';
import 'package:cosmic_assessments/view/screens/admin/tests/tests.dart';
import 'package:cosmic_assessments/view/screens/admin/users/users.dart';
import 'package:cosmic_assessments/view/screens/admin/users/view_user.dart';
import 'package:get/get.dart';

class AdminRoutes {
  static List<GetPage> routes = [
    GetPage(
      page: () => const AdminLandingScreen(
        title: 'Users',
      ),
      name: AdminLandingScreen.routeName,
    ),
    GetPage(
      page: () => const AdminUsersScreen(
        title: 'Users',
      ),
      name: AdminUsersScreen.routeName,
    ),
    GetPage(
      page: () => const AdminViewUser(
        title: 'View User',
      ),
      name: AdminViewUser.routeName,
    ),
    GetPage(
      page: () => const AdminAddNewUserPopup(
        title: 'Add Users',
      ),
      name: AdminAddNewUserPopup.routeName,
    ),
    GetPage(
      page: () => const AdminEditUserPopup(
        title: 'Edit Users',
      ),
      name: AdminEditUserPopup.routeName,
    ),
    GetPage(
      page: () => const AdminTestsScreen(
        title: 'Tests',
      ),
      name: AdminTestsScreen.routeName,
    ),
    GetPage(
      page: () => const AdminAddTestPopUp(
        title: 'Add Test',
      ),
      name: AdminAddTestPopUp.routeName,
    ),
    GetPage(
      page: () => const AdminEditTestPopUp(
        title: 'Edit Test',
      ),
      name: AdminEditTestPopUp.routeName,
    ),
    GetPage(
      page: () => const AdminManageTest(
        title: 'Manage Test',
      ),
      name: AdminManageTest.routeName,
    ),
    GetPage(
      page: () => const AdminTestSettings(
        title: 'Test Settings',
      ),
      name: AdminTestSettings.routeName,
    ),
    GetPage(
      page: () => const AdminAddQuestionPopUp(
        title: 'Add New Question',
      ),
      name: AdminAddQuestionPopUp.routeName,
    ),
    GetPage(
      page: () => const AdminEditQuestionPopUp(
        title: 'Edit Question',
      ),
      name: AdminEditQuestionPopUp.routeName,
    ),
    GetPage(
      page: () => const AdminTestQuestionsScreen(
        title: 'Questions',
      ),
      name: AdminTestQuestionsScreen.routeName,
    ),
    GetPage(
      page: () => const AdminStartTestScreen(
        title: 'Start Test',
      ),
      name: AdminStartTestScreen.routeName,
    ),
    GetPage(
      page: () => const AdminTestRunScreen(),
      name: AdminTestRunScreen.routeName,
    ),
    GetPage(
      page: () => const AdminTestSubmittedScreen(
        title: 'Test Submitted',
      ),
      name: AdminTestSubmittedScreen.routeName,
    ),
    GetPage(
      page: () => const AdminTestSubmissionsScreen(
        title: 'Test Submissions',
      ),
      name: AdminTestSubmissionsScreen.routeName,
    ),
    GetPage(
      page: () => const AdminTestReportScreen(
        title: 'Test Report',
      ),
      name: AdminTestReportScreen.routeName,
    ),
    GetPage(
      page: () => const AdminCoursesScreen(
        title: 'Courses',
      ),
      name: AdminCoursesScreen.routeName,
    ),
    GetPage(
      page: () => const AdminManageCourse(
        title: 'Manage Course',
      ),
      name: AdminManageCourse.routeName,
    ),
    GetPage(
      page: () => const AdminAddCoursePopUp(
        title: 'Add Course',
      ),
      name: AdminAddCoursePopUp.routeName,
    ),
    GetPage(
      page: () => const AdminEditCoursePopUp(
        title: 'Edit Course',
      ),
      name: AdminEditCoursePopUp.routeName,
    ),
    GetPage(
      page: () => const AdminAssignmentsScreen(
        title: 'Assignments',
      ),
      name: AdminAssignmentsScreen.routeName,
    ),
    GetPage(
      page: () => const AdminLessonsScreen(
        title: 'List Lessons',
      ),
      name: AdminLessonsScreen.routeName,
    ),
    GetPage(
      page: () => const AdminAddLessonPopup(
        title: 'Add Lessons',
      ),
      name: AdminAddLessonPopup.routeName,
    ),
    GetPage(
      page: () => const AdminEditLessonPopUp(
        title: 'Edit Lesson',
      ),
      name: AdminEditLessonPopUp.routeName,
    ),
    GetPage(
      page: () => const AdminViewLessonScreen(
        title: 'View Lesson',
      ),
      name: AdminViewLessonScreen.routeName,
    ),
    GetPage(
      page: () => const AdminViewSectionScreen(
        title: 'View Section',
      ),
      name: AdminViewSectionScreen.routeName,
    ),
    GetPage(
      page: () => const AdminAddLessonSectionPopup(
        title: 'Add Content',
      ),
      name: AdminAddLessonSectionPopup.routeName,
    ),
    GetPage(
      page: () => const AdminAddLessonContentPopup(
        title: 'Add Content',
      ),
      name: AdminAddLessonContentPopup.routeName,
    ),
    GetPage(
      page: () => const AdminEditLessonContentPopup(
        title: 'Edit Content',
      ),
      name: AdminEditLessonContentPopup.routeName,
    ),
    GetPage(
      page: () => const AdminPreviewContent(
        title: 'Preview Content',
      ),
      name: AdminPreviewContent.routeName,
    ),
    GetPage(
      page: () => const AdminBulkUploadQuestions(),
      name: AdminBulkUploadQuestions.routeName,
    ),
    GetPage(
      page: () => const AdminEnrollments(
        title: 'Enrollments',
      ),
      name: AdminEnrollments.routeName,
    ),
    GetPage(
      page: () => const AdminAddEnrolmentPopUp(
        title: 'Add Enrollment',
      ),
      name: AdminAddEnrolmentPopUp.routeName,
    ),
    GetPage(
      page: () => const AdminQnAScreen(
        title: 'List QnA',
      ),
      name: AdminQnAScreen.routeName,
    ),
    GetPage(
      page: () => const AdminSettings(),
      name: AdminSettings.routeName,
    ),
    GetPage(
      page: () => const AdminMeetingsList(
        title: 'Online Classes',
      ),
      name: AdminMeetingsList.routeName,
    ),
    GetPage(
      page: () => const AdminViewMeeting(
        title: 'Online Classes',
      ),
      name: AdminViewMeeting.routeName,
    ),
    GetPage(
      page: () => const AdminShareMeeting(
        title: 'Share Meeting',
        meetingGuid: '',
      ),
      name: AdminShareMeeting.routeName,
    ),
    GetPage(
      page: () => const AdminAddMeeting(
        title: 'Create Meeting',
      ),
      name: AdminAddMeeting.routeName,
    ),
    GetPage(
      page: () => const AdminEditMeeting(
        title: 'Edit Meeting',
        meetingGuid: '',
      ),
      name: AdminEditMeeting.routeName,
    ),
  ];
}
