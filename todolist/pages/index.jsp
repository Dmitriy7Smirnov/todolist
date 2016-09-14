<%@ page import="com.devcolibri.rest.domain.HibernateUtil" %>
<%@ page import="java.util.List" %>
<%@ page import="com.devcolibri.rest.domain.TodoListData" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Devcolibri.com exam REST</title>
    <style type="text/css">
        div{
            margin: 0 !important;
            padding: 0 !important;
            display: block;
        }
    </style>
</head>

<script src="//ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
<script type="text/javascript">

        $(document).ready(function(){
            $("#addNewTaskButton").bind("click",RestPost);
            $(".delete").bind("click", RestDelete);
            $(".update").bind("click", RestPut);
            $(".check-box").bind("change", RestPut)
            $("#completedTasks").bind("click", function(){
                $(".check-box:checked").parent().show();
                $(".check-box").not(":checked").parent().hide();
            });
            $("#undoneTasks").bind("click", function(){
                $(".check-box").not(":checked").parent().show();
                $(".check-box:checked").parent().hide();
            });
            $("#allTasks").bind("click", function(){
                $("span").show();
            });
        })

        var prefix = '/todolist/myservice';


        var RestPut = function () {
            var JSONObject = {
                "taskId": $(this).parent().attr('id'),
                "task": $("input[id^='input"+$(this).parent().attr('id')+"']").val(),
                "done": $("#checkbox"+$(this).parent().attr('id')).is(":checked")
            };

            $.ajax({
                type: 'PUT',
                url: prefix,
                contentType: 'application/json; charset=utf-8',
                data: JSON.stringify(JSONObject),
                dataType: 'json',
                async: true,
                success: function (result) {

                },
                error: function (jqXHR, textStatus, errorThrown) {
                    alert(jqXHR.status + ' ' + jqXHR.responseText);
                }
            });
        }


        var RestPost = function () {
            $.ajax({
                type: 'POST',
                url: prefix,
                contentType: 'application/json; charset=utf-8',
                data: JSON.stringify({task: $("#addNewTaskInput").val()}),
                dataType: 'json',
                async: true,
                success: function (result) {
                    location.reload();
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    alert(jqXHR.status + ' ' + jqXHR.responseText);
                }
            });
        }

        var RestDelete = function () {
            $.ajax({
                type: 'DELETE',
                url: prefix + '/' + $(this).parent().attr('id'),
                dataType: 'json',
                async: true,
                success: function (result) {
                    $("#"+result).remove();
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    alert(jqXHR.status + ' ' + jqXHR.responseText);
                }
            });
        }

</script>

<body>

    <h3>Todo list</h3>

    <br/>
    <button type="button" id="allTasks" >Все дела</button>
    <button type="button" id="undoneTasks">Только невыполненные</button>
    <button type="button" id="completedTasks" >Выполненные</button>
    <br/><br/>




    <%
        List<TodoListData> list = HibernateUtil.SelectFromDB("test");
        for (int i=0; i<list.size(); i++){
            String checked = "";
            if (list.get(i).getDone()) checked = "checked"; %>
          <span id="<%=list.get(i).getTaskId()%>">
          <input type="text" id="input<%=list.get(i).getTaskId()%>" value="<%=list.get(i).getTask()%>" style="width: 30%"/>
          <button type="button" class="update">Update</button>
          <input type="checkbox" id="checkbox<%=list.get(i).getTaskId()%>" class="check-box" <%=checked%>/><span>Is done</span>
          <button type="button" class="delete">Delete</button>
          <br/>
          </span>

        <%}
    %>

            <br/>
            <input type="text" id="addNewTaskInput" placeholder="Write new task here and press right button" style="width:30%"/>
            <button type="button" id="addNewTaskButton">Add new task</button>



</body>
</html>
