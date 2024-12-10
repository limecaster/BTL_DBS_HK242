import {
  Box,
  Input,
  Menu,
  MenuButton,
  MenuItem,
  MenuList,
  RadioGroup,
  SimpleGrid,
  Table,
  Tbody,
  Td,
  Tr,
} from '@chakra-ui/react';

import {
  Modal,
  ModalOverlay,
  ModalContent,
  ModalHeader,
  ModalFooter,
  ModalBody,
  ModalCloseButton,
  Button,
  useDisclosure,
  Radio,
} from '@chakra-ui/react';

import ColumnsTable from 'views/admin/dataTables/components/ColumnsTable';
import React from 'react';

interface CakeAdd {
  Name: string;
  Price: number;
  Type: int;
  CustomerNote: string;
  Status: string;
}

export default function Settings() {
  const [cakeData, setTableData] = React.useState([]);
  const [cakeColumns, setTableColumns] = React.useState([]);

  React.useEffect(() => {
    async function fetchCakeData() {
      const response = await fetch('http://localhost:3000/cake/getAll');
      const data = await response.json();

      const columns = Object.keys(data.result[0]).map((key) => ({
        Header: key,
        accessor: key,
      }));

      console.log(columns);
      console.log(data.result);

      setTableColumns(columns);
      setTableData(data.result);
    }

    fetchCakeData();
  }, []);

  //Modal control
  const cakeModal = useDisclosure({ id: 'cake' });
  const comboModal = useDisclosure({ id: 'combo' });

  const [addCakeType, setAddCakeType] = React.useState(0);

  return (
    <Box pt={{ base: '130px', md: '80px', xl: '80px' }}>
      {/* Cake Modal */}
      <Modal id="cake" isOpen={cakeModal.isOpen} onClose={cakeModal.onClose}>
        <ModalOverlay />
        <ModalContent>
          <ModalHeader>Add Cake</ModalHeader>
          <ModalCloseButton />
          <ModalBody>
            <Table>
              <Tbody>
                <Tr>
                  <Td>Name</Td>
                  <Td>
                    <Input type="text" id="Name" placeholder="Cake name" />
                  </Td>
                </Tr>
                <Tr>
                  <Td>Price</Td>
                  <Td>
                    <Input type="text" id="Price" placeholder="VND" />
                  </Td>
                </Tr>
                <Tr>
                  <Td>Type</Td>
                  <Td>
                    <RadioGroup defaultValue="0" onChange={setAddCakeType}>
                      <SimpleGrid columns={4} spacing={10}>
                        <Radio value="0">Salty</Radio>
                        <Radio value="1">Sweet</Radio>
                        <Radio value="2">Other</Radio>
                        <Radio value="3">Order</Radio>
                      </SimpleGrid>
                    </RadioGroup>
                  </Td>
                </Tr>
                <Tr>
                  <Td>Note</Td>
                  <Td>
                    <Input type="text" id="CustomerNote" placeholder="Note" disabled={addCakeType !== '3'} />
                  </Td>
                </Tr>
                
              </Tbody>
            </Table>
          </ModalBody>
          <ModalFooter>
            <Button variant="ghost" onClick={cakeModal.onClose}>
              Close
            </Button>
            <Button colorScheme="brand" mr={3}>
              Add
            </Button>
          </ModalFooter>
        </ModalContent>
      </Modal>

      {/* Combo Modal */}
      <Modal id="cake" isOpen={comboModal.isOpen} onClose={comboModal.onClose}>
        <ModalOverlay />
        <ModalContent>
          <ModalHeader>Modal Title</ModalHeader>
          <ModalCloseButton />
          <ModalBody>
            <p>Modal ID: combo</p>
          </ModalBody>
          <ModalFooter>
            <Button variant="ghost" onClick={comboModal.onClose}>
              Close
            </Button>
            <Button colorScheme="brand" mr={3}>
              Add
            </Button>
          </ModalFooter>
        </ModalContent>
      </Modal>

      <Menu>
        <MenuButton fontSize={{ base: '15px', lg: '20px' }}>➕ Add</MenuButton>
        <MenuList>
          <MenuItem onClick={cakeModal.onOpen}>🎂 Cake</MenuItem>
          <MenuItem onClick={comboModal.onOpen}>⚙️ Combo</MenuItem>
        </MenuList>
      </Menu>
      <ColumnsTable
        columnsData={cakeColumns}
        tableData={cakeData}
        tableName={'Cakes'}
      />
    </Box>
  );
}
