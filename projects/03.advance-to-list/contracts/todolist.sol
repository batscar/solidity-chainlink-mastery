// SPDX-License-Identifier: MIT
  pragma solidity ^0.8.21 ;

  contract AdvancedToDoList {
       
       address public immutable owner ;

       struct Task {
        uint256 id;
        string content;
        bool completed;
        uint256 createdAt;
        uint256 completedAt;
       }

       uint256 private taskCount;
       mapping(uint256 => Task) private tasks;
       mapping(address => uint256[]) public userTasks;

       event TaskCreated(uint256 indexed id, string content, address createdBy);
       event TaskCompleted(uint256 indexed id,bool completed, uint256 completedAt);
       event TaskUpdated(uint256 indexed id, string content);
       event TaskDeleted(uint256 indexed id);

       error OnlyOwnerCanCall();
       error TaskDoesNotExist();

       constructor() {
         owner = msg.sender;
        }

        function createTask(string memory _content) public {
            require(bytes(_content).length > 0, "Task content cannot be empty");
            taskCount++;

            tasks[taskCount] = Task ({
                id: taskCount,
                content: _content,
                completed: false,
                createdAt: block.timestamp,
                completedAt: 0
            });
        
            userTasks[msg.sender].push(taskCount);

            emit TaskCreated(taskCount, _content, msg.sender);

        }

        function deleteTask(uint _taskId) public {
            if (_taskId == 0 || _taskId > taskCount || tasks[_taskId].id == 0) {
                revert TaskDoesNotExist();
            }

           delete tasks[_taskId] ;
           emit TaskDeleted(_taskId); 
         }

        function getTask(uint256 _taskId) public view returns (Task memory) {
            if (_taskId == 0 || _taskId > taskCount || tasks[_taskId].id == 0) {
                revert TaskDoesNotExist();
            }

            return tasks[_taskId];
        }

        function deleteAllCompletedTasks() public {
        if (msg.sender != owner) {
            revert OnlyOwnerCanCall();
        }

        for (uint256 i = 1; i <= taskCount; i++) {
            if (tasks[i].id != 0 && tasks[i].completed) {
                delete tasks[i];
                emit TaskDeleted(i);
            }
        }
    }

        function getAllTasks() public view returns (Task[] memory) {
        Task[] memory allTasks = new Task[](taskCount);
        uint256 counter = 0;

        for (uint256 i = 1; i <= taskCount; i++) {
            if (tasks[i].id != 0) {
                allTasks[counter] = tasks[i];
                counter++;
            }
        }

        Task[] memory result = new Task[](counter);
        for (uint256 i = 0; i < counter; i++) {
            result[i] = allTasks[i];
        }

        return result;
    }

        function getMyTasks() public view returns (Task[] memory) {
            uint256[] memory myTaskIds = userTasks[msg.sender];
            Task[] memory myTasks = new Task[](myTaskIds.length);
            for (uint256 i = 0; i < myTaskIds.length; i++) {
                myTasks[i] = tasks[myTaskIds[i]];
            }
            return myTasks;
        }

        function getTaskCount() public view returns (uint256) {
            return taskCount;
        }

        function toggleComplete(uint256 _taskId) public {
        if (_taskId == 0 || _taskId > taskCount) {
            revert TaskDoesNotExist();
        }
        if (tasks[_taskId].id == 0) {
            revert TaskDoesNotExist();
        }

        Task storage task = tasks[_taskId];
        task.completed = !task.completed;
        
        if (task.completed) {
            task.completedAt = block.timestamp;
        } else {
            task.completedAt = 0;
        }

        emit TaskCompleted(_taskId, task.completed, task.completedAt);
    }

    function updateTask(uint256 _taskId, string memory _newContent) public {
        if (_taskId == 0 || _taskId > taskCount) {
            revert TaskDoesNotExist();
        }
        if (tasks[_taskId].id == 0) {
            revert TaskDoesNotExist();
        }

        tasks[_taskId].content = _newContent;

        emit TaskUpdated(_taskId, _newContent);
    }

        }



 


