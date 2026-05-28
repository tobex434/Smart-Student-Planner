# Design Documentation
## Smart Student Planner

---

## 1. App Purpose and Target Users

Smart Student planner is a productivity app built and designed specifically to help university students manage their academic workloads effectively. The app addresses the problem a lot of students share which is difficulty of tracking multiple assignments, deadlines of different modules, and various study sessions across the different courses the user is enrolled in. Without a dedicated tool, students often rely on making paper notes, generic calendar apps, or to memory, all of this can lead to missed deadlines or late submissions and a study habit that is disorganised.

Smart student planner provides students a single focused environment where they can create and manage their tasks which may be linked to a specific modules, they can also set and prioritise deadlines, track their progress and stay focused using the built in Pomodoro timer. The dashboard usually shows a quick weekly snapshot, it also highlights urgent tasks and any upcoming deadlines, this ensures that the student can view their most important works and any upcoming deadlines are always visible.

Problem domain: Academic tasks and deadline management for students in higher education.

Additional features: in addition other than the app having a login/signup, dashboard, Task management and validation features, the app also have a Pomodoro timer. The Pomodoro Timer is a time management tool that breaks your work into focused 25-minute intervals called "Pomodoros" separated by 5-minute short breaks, its a feature to boost productivity, the app also have Material 3 dynamic colour theming that reads the students wallpaper palettes on devices running Android 12 and above, a dark theme mode for accessibility and a multi account system where different users can login on the same app and manage their different tasks and deadlines independently of each account.

---

## 2. Wireframes and UI Sketches

The wireframes were created before the development of the app using a low fidelity sketch in figma. They map the layout of the various screens, component placement, and the navigation between screens. Wavy lines represents text, X-marked rectangles represents images, and circle with a X mark represent either avatars or icons. These wireframes shaped the implementation of the app, from the four tab navigation structure, the form field layout on a new task screen, layout of the various screens and placement of UI components.

Six screens where produced that covers the core journey of anyone using the app: they are divided into the: the content screens (this contains the Dashboard, Tasks, New Task Form and the Timer screen), the screens for authentication (the Splash, Login, and Sign up screen), and the account management screens (this contains the Profile and Settings screen).


<img width="396" height="1002" alt="Dashboard" src="https://github.com/user-attachments/assets/caa8e327-5f65-4845-ac32-d72810b72e2a" />

Figure 1: Dashboard (low-fidelity)


The dashboard wireframe shows the apps main content layout. It comprises the appbar wich sits at the top, the avatar to the right, an image placeholder to represent the active tasks, a floating action button to create new tasks and the bottom navbar that connects to the other main screens.

<img width="390" height="1278" alt="New task" src="https://github.com/user-attachments/assets/fa70dcd1-6948-4821-94a4-c153fbeeea62" />

Figure 2: New Task form wireframe (low-fidelity)


This wireframe maps out the screen for adding tasks, it was designed as a form, its made up  of the task title, task description, priority level of the task, deadline and time, and category modules to categorise tasks


<img width="390" height="884" alt="Splash" src="https://github.com/user-attachments/assets/86d258ee-4629-4b21-8a3c-08f0534f36a0" />
<img width="393" height="884" alt="Login" src="https://github.com/user-attachments/assets/50d3edb1-cbee-4b7b-aff6-a21cf15a5330" />

Figure 3: Login & Splash screen wireframe (low-fidelity)


<img width="390" height="1022" alt="Timer" src="https://github.com/user-attachments/assets/7ca40026-3ffa-407e-a614-cef14f506958" />

Figure 4: Timer screen wireframe (low-fidelity)

For the design of the of Pomodoro timer screen, it features two small equal pill buttons this represent the focus and break mode toggle, right Below it is the large circular placeholder that represents the custom clock dial, and right under it two small pill button that for Starting and resetting the timer.


<img width="390" height="1227" alt="Profile" src="https://github.com/user-attachments/assets/80382397-f4a8-4d4b-8064-5432ef815808" />

Figure 5: Profile / Settings screen wireframe (low-fidelity)

The profile wireframe shows both the profile and setting screens. The medium sized placeholder represents the avatar of the user, the three textfield below contain the users full name, University email and Course or major of the user.


<img width="390" height="1237" alt="Task list" src="https://github.com/user-attachments/assets/7b2f2605-a8d0-43e1-9e14-552012601a81" />

Figure 6: Tasks screen wireframe (low-fidelity)

The Task screen wireframe contains the title line that represents the tasks heading, the wide component represents the search bar where users can search the various task they have added, the three small button represents the the filter chips, this are used to categorise and isolate task s into a specific category, and a floating action button to add new tasks. 


---

## 3. Navigation Flow Diagram

<img width="2164" height="2793" alt="Navigational_flow_diagram" src="https://github.com/user-attachments/assets/365d0215-72f4-4018-b468-cf84d2303b04" />

Figure 7: Smart Student Planner — complete navigation flow diagram with all eleven screens with labelled transitions and trigger conditions.

For the flow of the app, it uses three navigation types which are Navigator.push for screens that need to be added onto the current stack (New Task, Profile) so that the user can return with the use of a back gesture. Navigator.pushReplacement is used after the user has been authenticated, so that the authentication screens can be removed from the stack, this prevents the user from being able able to go back to login or signup after entering the app. The final navigation type is the pushAndRemoveUntil, it is used when the the user clicks on the logout button in the profile screen, clicking it will clear the entire navigation stack and return to the landing page, this prevents the user from pressing the back button into the app, the user will have to sign in again or create another account.

---

## 4. Architecture Overview

<img width="2422" height="3328" alt="MVC_Architecture" src="https://github.com/user-attachments/assets/34a97fb9-b65e-4c8c-9601-999f32e194d4" />

Figure 8: MVC (Model-View-Controller) architecture implemented in
Smart Student Planner.

MVC (Model-View-Controller): This is an important design architecture for creating applications, it helps developers organise their code by splitting them into three components, which are the view, model and controller. MVC was chosen because as the codebase gets bigger and more complex, it can be difficult to maintain the codebase. MVC solves this by splitting the code into three components, the view which is responsible for the users see and how they interact with the app, Controller is responsible for the business logic of the app and it serves as the middle man between the view and model and finally the model, this contains the data layer of the app, it manages database interactions and notifies other components if they are any changes. The key advantage of using MVC architecture is it allows for quick identification and modification of specific features without affecting other parts of codebase.

In the smart student planner app, the view layer are the various screens we generated from the wireframes, these are the Login screen, Dashboard screen, Task screen, Profile screen. `the view doesn't interact with the database directly or contain any logic. Instead any actions required are passed to the relevant controller.

The controller layer, this where the business logic and state management of the app is located, some the actions that this layer do is Validating the inputs of the user, performing calculations, adding tasks to the database, carrying out CRUD operations on the model. After an action has been carried out the controllers calls the notifyListeners() function to update the UI of the app.

The model layer is composed of plain dart files and database service classes that are used to represent and store the structured data. Using an SQLite package called (sqlite), we can store relational data such as users of the app and the tasks. The task table is linked to users through a userID foreign key, this ensures users data stay isolated from each users. 


State management is the process of handling and maintaining the state of an application across different components, user interactions, and system updates. State management ensures consistency, efficiency, and synchronization across the app. To implement state management we use a flutter plugin called Provider with ChangeNotifier. Controllers are initialised as Multiprovider in the main.dart before start runApp(). The screens have a Context.watch<T>(), this allows the screens to rebuild whenever a notifylisteners() is called.


For data persistence, two methods were used. The Sqlite via sqflite  flutter plugin for storing relational data, the users table and tasks table, which are linked by a foreign key so that each users tasks are isolated foremother users, and the the final method is sharedPreferences, this is used for storing simple key value pair data structure such as the theme mode, the seedcolor, login session and usernames
