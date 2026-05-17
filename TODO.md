# SpendWise - Implementation ToDo

## Auth + Navigation Fix

- [x] Update `lib/main.dart` to use `FirebaseAuth.authStateChanges()` routing (avoid incorrect initialRoute based on `currentUser` at startup).
- [x] While auth state is unknown, show a splash/loading screen.
- [x] Keep onboarding preference (`showOnboarding`) logic, but apply it after auth state is known.
- [x] Add Home/Profile navigation UI to `MainDashboard`.
- [x] Add Home navigation/back action to `ProfileScreen`.
- [ ] Verify logout still works only from Profile.
- [ ] Run `flutter run` and sanity check flows.


