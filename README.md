# README
Gallery is a simple photos library with login/Register feature that allows user to get into home screen and show photo details. 

The Architecture used is MVVM with RX Swift, although it’s a simple project and I could simply use MVC, I preferred to choose MVVM as it’s better and easier in testing and decoupling the view and view model. 

Design Patterns:
•	Decorator Design Pattern in View Controller to extend the functionally of the view controller in an easy way to edit and maintain.
•	Observer Design Pattern in calculator View Model to update the listeners once the data changes.

Api: https://picsum.photos/v2/list?page=1&limit=10
 xcode: 13.1
