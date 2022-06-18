// SPDX-License-Identifier: GPL-3.0 
pragma solidity ^0.8.0;

contract ParentVehicle {
    function start() public pure returns(string memory){
        return ("The Vehicle has just Started");
    }
    function accelerate() public pure returns(string memory){
        return ("The Vehicle has just Accelerated");
    }
    function stop() public pure returns(string memory){
        return ("The Vehicle has just Stopped");
    }
    function service() public pure virtual returns(string memory){
        return ("The Vehicle is being serviced");
    }
}

contract cars is ParentVehicle {
    function service() public pure virtual override returns(string memory){
        return ("The car is being serviced");
    }
}

contract Truck is ParentVehicle {
    function service() public pure override virtual returns(string memory){
        return ("The truck is being serviced");
    }
}

contract MotorCycle is ParentVehicle {
    function service() public pure override virtual returns(string memory){
        return ("The Motor Cycle is being serviced");
    }
}

contract AltoMehran is cars {
    function service() public pure override returns(string memory){
        return ("The Alto-Mehran is being serviced");
    }
    
}
contract Hino is Truck {
     function service() public pure override virtual returns(string memory){
        return ("The Hino Truck is being serviced");
    }
    
}
contract Yamaha is MotorCycle {
    function service() public pure override virtual returns(string memory){
        return ("The Yamaha Motor Cycle is being serviced");
    }
    
}
contract ServiceStationCars {
    address Vehicle;
    function VehicleService(address _add) public returns(string memory){
        Vehicle = _add;
        AltoMehran car = AltoMehran(Vehicle);
        return (car.service());
    }
}
contract ServiceStationTruck {
    address Vehicle;
    function VehicleService(address _add) public returns(string memory){
        Vehicle = _add;
        Truck truck = Truck(Vehicle);
        return (truck.service());
    }
}
contract ServiceStationMotorCycle {
    address Vehicle;
    function VehicleService(address _add) public returns(string memory){
        Vehicle = _add;
        MotorCycle motorcycle = MotorCycle(Vehicle);
        return (motorcycle.service());
    }
}