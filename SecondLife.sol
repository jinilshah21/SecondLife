//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract SecondLife {
    address owner;

    constructor() {
        owner = msg.sender;
    }

    struct patient {
        uint id;
        address addr;
        string name;
        string[] donation;
        string[] ask;
    }

    struct blooddonation {
        string bloodtype;
        uint amount;
        address tohospital;
        address frompatient;
    }

    struct organdonation {
        uint amount;
        string organname;
        address frompatient;
        address tohospital;
    }

    struct bloodsupplied {
        uint amount;
        string bloodtype;
        address topatient;
        address fromhospital;
    }

    struct organsupplied {
        uint amount;
        string organname;
        address topatient;
        address fromhospital;
    }

    struct hospital {
        uint id;
        address addrh;
        string name;
        // blooddonation[] bloodDonated;
        // organdonation[] organDonated;
        // bloodsupplied[] bloodSupplied;
        // organsupplied[] organSupplied;
        address[] appointmentQueue;
    }

    patient[] public patients;
    patient[] public donars;
    hospital[] hospitals;
    mapping(uint => patient) ispatient;
    mapping(uint => hospital) ishospital;
    //mapping(uint => address) isdonar;
    uint Id1 = 0;
    uint Id2 = 0;
    string[] _donations;
    string[] _ask;

    function patientReg(string memory _name) public {
        // if(Id1 > 0){
        //     for(uint i = 0 ; i < Id1 ; i++){
        //         require(ispatient[i].addr != msg.sender, "Already registered");
        //     }
        // }
        patients.push(patient(Id1, msg.sender, _name, _donations, _ask));
        ispatient[Id1] = patients[Id1];
        Id1++;
    }

    organsupplied[] public _organsupply;
    bloodsupplied[] public _bloodsupply;
    organdonation[] public _organdonated;
    blooddonation[] public _blooddonated;
    address[] _appointmentQueue;

    function HospitalReg(address hospitalsaddr, string memory _name) public {
        require(owner == msg.sender, "You are not the owner");
        // if(Id2 > 0){
        //     for(uint i = 0 ; i < Id2 ; i++){
        //         require(ishospital[i].addrh == hospitalsaddr, "Already registered");
        //     }
        // }
        hospitals.push(hospital(Id1, hospitalsaddr, _name, _appointmentQueue));
        ishospital[Id2] = hospitals[Id2];
        Id2++;
    }

    function bookAppointment(address hospitalAddr) public {
        for (uint i = 0; i < hospitals.length; i++) {
            if (hospitals[i].addrh == hospitalAddr) {
                hospitals[i].appointmentQueue.push(msg.sender);
                break;
            }
        }
    }

    function getHospitalDetails(
        uint hospitalid
    ) public view returns (uint, address, string memory, address[] memory) {
        return (
            hospitals[hospitalid].id,
            hospitals[hospitalid].addrh,
            hospitals[hospitalid].name,
            hospitals[hospitalid].appointmentQueue
        );
    }

    // struct organdonation{
    //     uint amount;
    //     string organname;
    //     address frompatient;
    //     address tohospital;
    // }

    function donate(
        uint patientid,
        uint hospitalid,
        bool blood,
        bool organ,
        uint bloodamt,
        string memory bloodtype,
        string memory organname
    ) public {
        require(ispatient[patientid].addr == msg.sender, "Not Registered");
        bool status = false;
        for (
            uint i = 0;
            i < hospitals[hospitalid].appointmentQueue.length;
            i++
        ) {
            if (
                hospitals[hospitalid].appointmentQueue[i] ==
                patients[patientid].addr
            ) {
                status = true;
            } else continue;
        }
        require(status == true, "Take an Appointmennt");

        if (blood == true) {
            _blooddonated.push(
                blooddonation(
                    bloodtype,
                    bloodamt,
                    hospitals[hospitalid].addrh,
                    msg.sender
                )
            );
        } else if (organ == true) {
            _organdonated.push(
                organdonation(
                    1,
                    organname,
                    msg.sender,
                    hospitals[hospitalid].addrh
                )
            );
        } else if (organ == true && blood == true) {
            _blooddonated.push(
                blooddonation(
                    bloodtype,
                    bloodamt,
                    hospitals[hospitalid].addrh,
                    msg.sender
                )
            );
            _organdonated.push(
                organdonation(
                    1,
                    organname,
                    msg.sender,
                    hospitals[hospitalid].addrh
                )
            );
        }
        donars.push(patients[patientid]);
    }

    // function ask() public {

    // }
    // function disposal() public {

    // }
}
