'use client';
/* eslint-disable */

import {
    Box,
    Flex,
    Table,
    Tbody,
    Td,
    Text,
    Th,
    Thead,
    Tr,
    useColorModeValue,
} from '@chakra-ui/react';
import {
    createColumnHelper,
    flexRender,
    getCoreRowModel,
    getSortedRowModel,
    useReactTable,
} from '@tanstack/react-table';
// Custom components
import Card from 'components/card/Card';
import * as React from 'react';
// Assets

// API
import { getAllIngredients, createIngredient, updateIngredient, deleteIngredient } from '../api/tableIngredient';
import { Button, Modal, ModalOverlay, ModalContent, ModalHeader, ModalFooter, ModalBody, ModalCloseButton, Input, useDisclosure } from '@chakra-ui/react';

const columnHelper = createColumnHelper();

function AddIngredientModal({ isOpen, onClose, onAdd }) {
    const [name, setName] = React.useState('');
    const [importPrice, setImportPrice] = React.useState('');

    const handleAdd = () => {
        onAdd({ name, importPrice });
        setName('');
        setImportPrice('');
        onClose();
    };

    return (
        <Modal isOpen={isOpen} onClose={onClose}>
            <ModalOverlay />
            <ModalContent>
                <ModalHeader>Thêm nguyên liệu mới</ModalHeader>
                <ModalCloseButton />
                <ModalBody>
                    <Input
                        placeholder="Tên nguyên liệu"
                        value={name}
                        onChange={(e) => setName(e.target.value)}
                        mb={4}
                    />
                    <Input
                        placeholder="Giá nhập"
                        value={importPrice}
                        onChange={(e) => setImportPrice(e.target.value)}
                    />
                </ModalBody>
                <ModalFooter>
                    <Button colorScheme="blue" mr={3} onClick={handleAdd}>
                        Thêm
                    </Button>
                    <Button variant="ghost" onClick={onClose}>Hủy</Button>
                </ModalFooter>
            </ModalContent>
        </Modal>
    );
}

function EditIngredientModal({ isOpen, onClose, onEdit, ingredient }) {
    const [name, setName] = React.useState(ingredient?.name || '');
    const [importPrice, setImportPrice] = React.useState(ingredient?.importPrice || '');

    const handleEdit = () => {
        onEdit({ ...ingredient, name, importPrice });
        onClose();
    };

    React.useEffect(() => {
        setName(ingredient?.name || '');
        setImportPrice(ingredient?.importPrice || '');
    }, [ingredient]);

    return (
        <Modal isOpen={isOpen} onClose={onClose}>
            <ModalOverlay />
            <ModalContent>
                <ModalHeader>Chỉnh sửa nguyên liệu</ModalHeader>
                <ModalCloseButton />
                <ModalBody>
                    <Input
                        placeholder="Tên nguyên liệu"
                        value={name}
                        onChange={(e) => setName(e.target.value)}
                        mb={4}
                    />
                    <Input
                        placeholder="Giá nhập"
                        value={importPrice}
                        onChange={(e) => setImportPrice(e.target.value)}
                    />
                </ModalBody>
                <ModalFooter>
                    <Button colorScheme="blue" mr={3} onClick={handleEdit}>
                        Lưu
                    </Button>
                    <Button variant="ghost" onClick={onClose}>Hủy</Button>
                </ModalFooter>
            </ModalContent>
        </Modal>
    );
}

export default function ComplexTable() {
    const [sorting, setSorting] = React.useState([]);
    const [ingredientData, setIngredientData] = React.useState([]);
    const [selectedIngredient, setSelectedIngredient] = React.useState(null);
    const textColor = useColorModeValue('secondaryGray.900', 'white');
    const borderColor = useColorModeValue('gray.200', 'whiteAlpha.100');
    const { isOpen: isAddOpen, onOpen: onAddOpen, onClose: onAddClose } = useDisclosure();
    const { isOpen: isEditOpen, onOpen: onEditOpen, onClose: onEditClose } = useDisclosure();

    const fetchData = async () => {
        const data = await getAllIngredients();
        setIngredientData(data);
    };

    const handleAddIngredient = async (newIngredient) => {
        await createIngredient({ name: newIngredient.name, importPrice: newIngredient.importPrice });
        fetchData();
    };

    const handleEditIngredient = async (updatedIngredient) => {
        await updateIngredient(updatedIngredient);
        fetchData();
    };

    const handleDeleteIngredient = async (ingredientId) => {
        await deleteIngredient(ingredientId);
        fetchData();
    };

    React.useEffect(() => {
        fetchData();
    }, []);

    let defaultData = ingredientData;

    const columns = [
        columnHelper.accessor('ID', {
            id: 'ID',
            header: () => (
                <Text
                    justifyContent="space-between"
                    align="center"
                    fontSize={{ sm: '10px', lg: '12px' }}
                    color="gray.400"
                >
                    ID
                </Text>
            ),
            cell: (info) => (
                <Flex align="center">
                    <Text color={textColor} fontSize="sm" fontWeight="700">
                        {info.getValue()}
                    </Text>
                </Flex>
            ),
        }),
        columnHelper.accessor('Name', {
            id: 'Name',
            header: () => (
                <Text
                    justifyContent="space-between"
                    align="center"
                    fontSize={{ sm: '10px', lg: '12px' }}
                    color="gray.400"
                >
                    Tên nguyên liệu
                </Text>
            ),
            cell: (info) => (
                <Flex align="center">
                    <Text color={textColor} fontSize="sm" fontWeight="700">
                        {info.getValue()}
                    </Text>
                </Flex>
            ),
        }),
        columnHelper.accessor('ImportPrice', {
            id: 'ImportPrice',
            header: () => (
                <Text
                    justifyContent="space-between"
                    align="center"
                    fontSize={{ sm: '10px', lg: '12px' }}
                    color="gray.400"
                >
                    Giá nhập
                </Text>
            ),
            cell: (info) => (
                <Text color={textColor} fontSize="sm" fontWeight="700">
                    {info.getValue()}
                </Text>
            ),
        }),
        columnHelper.accessor('Status', {
            id: 'Status',
            header: () => (
                <Text
                    justifyContent="space-between"
                    align="center"
                    fontSize={{ sm: '10px', lg: '12px' }}
                    color="gray.400"
                >
                    Trạng thái
                </Text>
            ),
            cell: (info) => (
                <Flex align="center">
                    <Text color={textColor} fontSize="sm" fontWeight="700">
                        {info.getValue()}
                    </Text>
                </Flex>
            ),
        }),
        {
            id: 'actions',
            header: () => (
                <Text
                    justifyContent="space-between"
                    align="center"
                    fontSize={{ sm: '10px', lg: '12px' }}
                    color="gray.400"
                >
                    Hành động
                </Text>
            ),
            cell: (info) => (
                <Flex align="center">
                    <Button size="sm" colorScheme="blue" onClick={() => { setSelectedIngredient(info.row.original); onEditOpen(); }}>
                        Sửa
                    </Button>
                    <Button size="sm" colorScheme="red" ml={2} onClick={() => handleDeleteIngredient(info.row.original.ID)}>
                        Xóa
                    </Button>
                </Flex>
            ),
        },
    ];
    const data = React.useMemo(() => [...defaultData], [defaultData]);
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
    return (
        <Card
            flexDirection="column"
            w="100%"
            px="0px"
            overflowX={{ sm: 'scroll', lg: 'hidden' }}
        >
            <Flex px="25px" mb="8px" justifyContent="space-between" align="center">
                <Text
                    color={textColor}
                    fontSize="22px"
                    fontWeight="700"
                    lineHeight="100%"
                >
                    Danh sách nguyên liệu bánh
                </Text>
                <Button onClick={onAddOpen} colorScheme="blue">Thêm nguyên liệu</Button>
                {/* <Menu /> */}
            </Flex>
            <Box>
                <Table variant="simple" color="gray.500" mb="24px" mt="12px">
                    <Thead>
                        {table.getHeaderGroups().map((headerGroup) => (
                            <Tr key={headerGroup.id}>
                                {headerGroup.headers.map((header) => {
                                    return (
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
                                                {{
                                                    asc: '',
                                                    desc: '',
                                                }[header.column.getIsSorted()] ?? null}
                                            </Flex>
                                        </Th>
                                    );
                                })}
                            </Tr>
                        ))}
                    </Thead>
                    <Tbody>
                        {table
                            .getRowModel()
                            .rows.slice(0, 11)
                            .map((row) => {
                                return (
                                    <Tr key={row.id}>
                                        {row.getVisibleCells().map((cell) => {
                                            return (
                                                <Td
                                                    key={cell.id}
                                                    fontSize={{ sm: '14px' }}
                                                    minW={{ sm: '150px', md: '200px', lg: 'auto' }}
                                                    borderColor="transparent"
                                                >
                                                    {flexRender(
                                                        cell.column.columnDef.cell,
                                                        cell.getContext(),
                                                    )}
                                                </Td>
                                            );
                                        })}
                                    </Tr>
                                );
                            })}
                    </Tbody>
                </Table>
            </Box>
            <AddIngredientModal isOpen={isAddOpen} onClose={onAddClose} onAdd={handleAddIngredient} />
            <EditIngredientModal isOpen={isEditOpen} onClose={onEditClose} onEdit={handleEditIngredient} ingredient={selectedIngredient} />
        </Card>
    );
}
