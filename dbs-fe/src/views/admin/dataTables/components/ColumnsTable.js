/* eslint-disable */

import {
  Flex,
  Box,
  Table,
  Tbody,
  Td,
  Text,
  Th,
  Thead,
  Tr,
  useColorModeValue,
  Button,
  useDisclosure,
  Input,
  RadioGroup,
  SimpleGrid,
  Radio
} from '@chakra-ui/react';
import {
  Modal,
  ModalOverlay,
  ModalContent,
  ModalHeader,
  ModalFooter,
  ModalBody,
  ModalCloseButton,
} from "@chakra-ui/react"
import * as React from 'react';

import {
  createColumnHelper,
  flexRender,
  getCoreRowModel,
  getSortedRowModel,
  useReactTable,
} from '@tanstack/react-table';

// Custom components
import Card from 'components/card/Card';
import Menu from 'components/menu/MainMenu';

const columnHelper = createColumnHelper();

export default function ColumnsTable({ columnsData, tableData, tableName }) {
  const [sorting, setSorting] = React.useState([]);
  const textColor = useColorModeValue('secondaryGray.900', 'white');
  const borderColor = useColorModeValue('gray.200', 'whiteAlpha.100');

  const columns = React.useMemo(() => columnsData.map((column) =>
    columnHelper.accessor(column.accessor, {
      header: () => (
        <Text
          justifyContent="space-between"
          align="center"
          fontSize={{ sm: '10px', lg: '12px' }}
          color="gray.400"
        >
          {column.Header}
        </Text>
      ),
      cell: (info) => (
        <Text color={textColor} fontSize="sm" fontWeight="700">
          {info.getValue()}
        </Text>
      ),
    })
  ), [columnsData, textColor]);

  const data = React.useMemo(() => tableData, [tableData]);

  const table = useReactTable({
    data,
    columns,
    state: {
      sorting,
    },
    onSortingChange: setSorting,
    getCoreRowModel: getCoreRowModel(),
    getSortedRowModel: getSortedRowModel(),
    debugTable: true,
  });

  const handleDelete = async (id) => {
    try {
      const response = await fetch('http://localhost:3001/cake/delete/' + id, {
        method: 'DELETE',
        headers: {
          'Content-Type': 'application/json',
        },
      });

      if (response.ok) {
        alert('Xóa bánh thành công');
      } else {
        alert('Xóa bánh thất bại: ', response);
      }
    } catch (error) {
      alert('Xóa bánh thất bại:', error);
    }

    window.location.reload();
  }

  const updateCakeModal = useDisclosure({ id: 'updateCake' });

  const [updateCakeID, setUpdateCakeID] = React.useState(-1);
  const [updateCakeName, setUpdateCakeName] = React.useState('');
  const [updateCakePrice, setUpdateCakePrice] = React.useState(0);
  const [updateCakeType, setUpdateCakeType] = React.useState('0');
  const [updateCakeNote, setUpdateCakeNote] = React.useState('');

  const handleUpdateCake = async () => {
    if (updateCakeName === '') {
      alert('Vui lòng đặt tên bánh');
      return;
    }

    if (updateCakePrice === 0) {
      alert('Vui lòng nhập giá bánh');
      return;
    }

    if (updateCakePrice < 0) {
      alert('Giá bánh không hợp lệ');
      return;
    }

    if (updateCakeType === "3" && updateCakeNote === '') {
      alert('Vui lòng nhập ghi chú của khách hàng');
      return;
    }

    if (updateCakeType !== "3") setUpdateCakeNote('');
    try {
      const response = await fetch('http://localhost:3001/cake/update/' + updateCakeID, {
        method: 'PATCH',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          name: updateCakeName,
          price: parseInt(updateCakePrice, 10),
          isSalty: updateCakeType === '0',
          isSweet: updateCakeType === '1',
          isOther: updateCakeType === '2',
          isOrder: updateCakeType === '3',
          customerNote: updateCakeNote,
        }),
      });

      if (response.ok) {
        alert('Cập nhật bánh thành công');
      } else {
        alert('Cập nhật bánh thất bại: ', response);
      }
    } catch (error) {
      alert('Cập nhật bánh thất bại:', error);
    }

    window.location.reload();
  }

  return (
    <Card
      flexDirection="column"
      w="100%"
      px="0px"
      overflowX={{ sm: 'scroll', lg: 'hidden' }}
    >
      <Modal id="cake" isOpen={updateCakeModal.isOpen} onClose={updateCakeModal.onClose}>
        <ModalOverlay />
        <ModalContent>
          <ModalHeader>Edit cake</ModalHeader>
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
                      value={updateCakeName}
                      onChange={(e) => setUpdateCakeName(e.target.value)}
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
                      value={updateCakePrice}
                      onChange={(e) => setUpdateCakePrice(e.target.value)}
                    />
                  </Td>
                </Tr>
                <Tr>
                  <Td>Type</Td>
                  <Td>
                    <RadioGroup
                      defaultValue={updateCakeType}
                      value={updateCakeType}
                      onChange={(value) => setUpdateCakeType(value)}
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
                      value={updateCakeNote}
                      disabled={updateCakeType !== '3'}
                      onChange={(e) => setUpdateCakeNote(e.target.value)}
                    />
                  </Td>
                </Tr>
              </Tbody>
            </Table>
          </ModalBody>
          <ModalFooter>
            <Button variant="ghost" onClick={updateCakeModal.onClose}>
              Close
            </Button>
            <Button colorScheme="brand" mr={3} onClick={handleUpdateCake}>
              Update
            </Button>
          </ModalFooter>
        </ModalContent>
      </Modal>
      <Flex px="25px" mb="8px" justifyContent="space-between" align="center">
        <Text
          color={textColor}
          fontSize="22px"
          mb="4px"
          fontWeight="700"
          lineHeight="100%"
        >
          {tableName}
        </Text>
        <Menu />
      </Flex>
      <Box>
        <Table variant="simple" color="gray.500" mb="24px" mt="12px">
          <Thead>
            {table.getHeaderGroups().map((headerGroup) => (
              <Tr key={headerGroup.id}>
                {headerGroup.headers.map((header) => (
                  <Th
                    key={header.id}
                    colSpan={header.colSpan}
                    pe="10px"
                    borderColor={borderColor}
                    cursor="pointer"
                    onClick={header.column.getToggleSortingHandler()}
                  >
                    <Flex
                      justifyContent="space-between"
                      align="center"
                      fontSize={{ sm: '10px', lg: '12px' }}
                      color="gray.400"
                    >
                      {flexRender(
                        header.column.columnDef.header,
                        header.getContext(),
                      )}
                      {header.column.getIsSorted() ? (
                        header.column.getIsSorted() === 'asc' ? ' 🔼' : ' 🔽'
                      ) : null}
                    </Flex>
                  </Th>
                ))}
              </Tr>
            ))}
          </Thead>
          <Tbody>
            {table.getRowModel().rows.map((row) => (
              <Tr key={row.id}>
                {row.getVisibleCells().map((cell) => (
                  <Td
                    key={cell.id}
                    fontSize={{ sm: '14px' }}
                    minW={{ sm: '150px', md: '200px', lg: 'auto' }}
                    borderColor="transparent"
                  >
                    {typeof cell.getValue() === 'boolean' ? (
                      cell.getValue() ? '✅' : '❌'
                    ) : (
                      flexRender(cell.column.columnDef.cell, cell.getContext())
                    )}
                  </Td>
                ))}
                <Td>
                  <Button onClick={() => {
                    const data = tableData[row.id];
                    console.log(data);
                    console.log(data['ID']);
                    const id = data['ID'];

                    handleDelete(id);
                  }}
                  >🗑️</Button>
                </Td>
                <Td>
                  <Button onClick={(e) => {
                    const data = tableData[row.id];
                    console.log(data);
                    console.log(data['ID']);

                    setUpdateCakeID(data['ID']);

                    setUpdateCakeName(data['Name']);
                    setUpdateCakePrice(data['Price']);
                    
                    if (data['IsSalty'] == true) setUpdateCakeType("0");
                    if (data['IsSweet'] == true) setUpdateCakeType("1");
                    if (data['IsOther'] == true) setUpdateCakeType("2");
                    if (data['IsOrder'] == true) setUpdateCakeType("3");

                    setUpdateCakeNote(data['CustomerNote'] || '');

                    updateCakeModal.onOpen();
                  }}
                  >📝</Button>
                </Td>
              </Tr>
            ))}
          </Tbody>
        </Table>
      </Box>
    </Card>
  );
}