import { Box, Breadcrumb, BreadcrumbItem, BreadcrumbLink, Flex, Link, Text, useColorModeValue } from '@chakra-ui/react';
import React from "react";

// Chakra imports

// Custom components
import { HorizonLogo } from "components/icons/Icons";
import { HSeparator } from "components/separator/Separator";
import { color } from "framer-motion";

export function SidebarBrand() {
  //   Chakra color mode
	let mainText = useColorModeValue('navy.700', 'white');

  return (
    <Flex align='center' direction='column'>
        <Link
          color={mainText}
          href='#'
          bg='inherit'
          borderRadius='inherit'
          fontWeight='bold'
          fontSize='34px'
          _hover={{ color: { mainText } }}
          _active={{
            bg: 'inherit',
            transform: 'none',
            borderColor: 'transparent'
          }}
          _focus={{
            boxShadow: 'none'
          }}>
          {"Bakery"}
        </Link>
      <HSeparator mb='20px' />
    </Flex>
  );
}

export default SidebarBrand;
