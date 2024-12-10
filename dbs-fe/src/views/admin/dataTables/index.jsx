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

export default function Settings() {
  const [cakeData, setTableData] = React.useState([]);
  const [cakeColumns, setTableColumns] = React.useState([]);

  React.useEffect(() => {
    async function fetchCakeData() {
      const response = await fetch('http://localhost:3001/cake/getAll');
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

  // Modal control
  const cakeModal = useDisclosure({ id: 'cake' });
  const comboModal = useDisclosure({ id: 'combo' });

  const [addCakeName, setAddCakeName] = React.useState('');
  const [addCakePrice, setAddCakePrice] = React.useState(0);
  const [addCakeType, setAddCakeType] = React.useState('0');
  const [addCakeNote, setAddCakeNote] = React.useState('');

  const addCakeClear = () => {
    setAddCakeName('');
    setAddCakePrice(0);
    setAddCakeType('0');
    setAddCakeNote('');
  };

  const handleAddCake = async () => {
    if (addCakeName === '') {
      alert('Vui lòng đặt tên bánh');
      return;
    }

    if (addCakePrice === 0) {
      alert('Vui lòng nhập giá bánh');
      return;
    }

    if (addCakePrice < 0) {
      alert('Giá bánh không hợp lệ');
      return;
    }

    if (addCakeType === '3' && addCakeNote === '') {
      alert('Vui lòng nhập ghi chú của khách hàng');
      return;
    }

    if (addCakeType !== '3') setAddCakeNote('');
    try {
      const response = await fetch('http://localhost:3001/cake/create', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          name: addCakeName,
          price: parseInt(addCakePrice, 10),
          isSalty: addCakeType === '0',
          isSweet: addCakeType === '1',
          isOther: addCakeType === '2',
          isOrder: addCakeType === '3',
          customerNote: addCakeNote,
        }),
      });

      const data = await response.json();
      console.log(data);

      addCakeClear();
      alert('Thêm bánh thành công');
    } catch (err) {
      console.log(err);
      alert('Thêm bánh thất bại');
    }
  };

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
                    <Input
                      type="text"
                      id="Name"
                      placeholder="Cake name"
                      value={addCakeName}
                      onChange={(e) => setAddCakeName(e.target.value)}
                    />
                  </Td>
                </Tr>
                <Tr>
                  <Td>Price</Td>
                  <Td>
                    <Input
                      type="number"
                      id="Price"
                      placeholder="VND"
                      value={addCakePrice}
                      onChange={(e) => setAddCakePrice(e.target.value)}
                    />
                  </Td>
                </Tr>
                <Tr>
                  <Td>Type</Td>
                  <Td>
                    <RadioGroup
                      defaultValue="0"
                      value={addCakeType}
                      onChange={(value) => setAddCakeType(value)}
                    >
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
                    <Input
                      type="text"
                      id="CustomerNote"
                      placeholder="Note"
                      value={addCakeNote}
                      disabled={addCakeType !== '3'}
                      onChange={(e) => setAddCakeNote(e.target.value)}
                    />
                  </Td>
                </Tr>
              </Tbody>
            </Table>
          </ModalBody>
          <ModalFooter>
            <Button variant="ghost" onClick={cakeModal.onClose}>
              Close
            </Button>
            <Button colorScheme="brand" mr={3} onClick={handleAddCake}>
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