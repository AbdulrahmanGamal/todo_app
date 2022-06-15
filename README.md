# Flutter · TODO web and mobile app

To-do List app using with Firebase, using RiverPod as state management and dependency injection.

### to run the application execute the following command

```bash
docker-compose up
```

- Also its accessible throw this link : http://localhost:8080/#/todo

### to run project unit test and widget test use

```bash
flutter test
```

#### Testing coverage

![Coverage](readme_images/coverage_badge.svg?sanitize=true)

### Firebase Scheme

    ├── todos
      ├── id (generated)
        ├── finalDate (Number)
        ├── isCompleted (Boolean)
        ├── subject (String)

### Project Architecture

- Remote Service : managing remote connection with firebase
- Repository : talking to data sources to prepare the data
- ViewModel : Managing differnet ui states and provide streams for ui
- UI : presentation layer containing Screens and custom widgets used in the app

### Navigator 2.0

Actually the project has been implemented with **Navigator 2.0** or **Route API**.

### Responsive and Adaptive

This To-do app project uses responsive and adaptive principles to use it on different screen sizes
and any devices, like mobile phones, tablets, computers, notebooks, etc.

### Project screenshots

<table>
<tr>
    <td><img src="readme_images/web1.png" ></td>


</tr>
<tr>
   img src="readme_images/web2.png" ></td>
</tr>
<tr>
    <td><img src="readme_images/web3.png" ></td>
</tr>

</table>


<table>
  <tr>
    <td><img src="readme_images/android1.png"  width=270 height=480></td>
    <td><img src="readme_images/android2.png"  width=270 height=480></td>
  </tr>
<tr>
    <td><img src="readme_images/android3.png"  width=270 height=480></td>
    <td><img src="readme_images/android4.png"  width=270 height=480></td>
  </tr>
<tr>
    <td><img src="readme_images/android5.png"  width=270 height=480></td>
    <td><img src="readme_images/android6.png"  width=270 height=480></td>
</tr>
<tr>
    <td><img src="readme_images/android7.png" width=270 height=480></td>
  </tr>
 </table>

